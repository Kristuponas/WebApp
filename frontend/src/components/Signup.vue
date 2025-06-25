<template>
    <div class="auth-container">
        <header class="header-bar">
            <a href="/home">ReserveIt.com</a>
        </header>
        <div class="wrapper">
            <form @submit.prevent="handleSignup">
                <h1>Sign Up</h1>
                <div class="input-box">
                    <input type="text" placeholder="Username" required v-model="username">
                    <i class="bx bxs-user"></i>
                </div>
                <div class="input-box">
                    <input type="email" placeholder="Email" required v-model="email">
                    <i class="bx bxs-envelope"></i>
                </div>
                <div class="input-box">
                    <input
                        :type="show.password ? 'text' : 'password'"
                        placeholder="Password"
                        required
                        v-model="password"
                    />
                    <i
                        :class="show.password ? 'bx bxs-show' : 'bx bxs-hide'"
                        @click="toggle('password')"
                    ></i>
                </div>

                <div class="password-criteria">
                    <p>Password must contain:</p>
                    <ul>
                        <li :class="isMinLength ? 'valid-password' : 'invalid-password'">At least 8 characters</li>
                        <li :class="hasUppercase ? 'valid-password' : 'invalid-password'">At least 1 uppercase character (A-Z)</li>
                        <li :class="hasLowercase ? 'valid-password' : 'invalid-password'">At least 1 lowercase character (a-z)</li>
                        <li :class="hasDigit ? 'valid-password' : 'invalid-password'">At least 1 numeric digit (0-9)</li>
                        <li :class="hasSpecial ? 'valid-password' : 'invalid-password'">At least 1 special character (e.g., !@#$%^&*()).</li>
                    </ul>
                </div>

                <div class="input-box">
                    <input
                        :type="show.rPassword ? 'text' : 'password'"
                        placeholder="Confirm Password"
                        required
                        v-model="rPassword"
                    />
                    <i
                        :class="show.rPassword ? 'bx bxs-show' : 'bx bxs-hide'"
                        @click="toggle('rPassword')"
                    ></i>
                </div>

                <div class="error-holder">
                    <p v-if="error" style="color: var(--invalid-pass); font-size: 0.9em">*{{ error }}</p>
                </div>

                <button type="submit" class="btn">Sign Up</button>

                <div class="redirect-link">
                    <p>Already have an Account? <a href="/signin"><i>Sign In</i></a></p>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            username: '',
            email: '',
            password: '',
            rPassword: '',
            error: '',
            show: {
                password: false,
                rPassword: false
            },
            isMinLength: false,
            hasUppercase: false,
            hasLowercase: false,
            hasDigit: false,
            hasSpecial: false
        }
    },
    methods: {
        toggle(field) {
            this.show[field] = !this.show[field];
        },

        async handleSignup() {
            this.error = '';

            // Check if passwords match
            if (this.password !== this.rPassword) {
                this.error = "Both passwords must match";
                return;
            }

            if(!this.isMinLength || !this.hasUppercase || !this.hasLowercase || !this.hasDigit || !this.hasSpecial) {
                this.error = "Password does not match criteria."
                return;
            }

            try {
                const response = await fetch("http://localhost:8080/signup", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    username: this.username,
                    email: this.email,
                    password: this.password
                })
            });

            const result = await response.json();

            if (!response.ok || !result.success) {
                this.error = result.message || "Signup failed";
            } else {
                console.log("Signup success:", result.message);
                this.$router.push("/signin");
            }

            } catch (err) {
                console.error(err);
                this.error = "Server error. Please try again.";
            }   
        }
    }, 
    watch: {
        password(value) {
            this.isMinLength = value.length >= 8;
            this.hasUppercase = /[A-Z]/.test(value);
            this.hasLowercase = /[a-z]/.test(value);
            this.hasDigit = /\d/.test(value);
            this.hasSpecial = /[!@#$%^&*(),.?'"{}|<>:;\[\]\\\\-_=+]/.test(value);
        }
    }
}

</script>

<style scoped>
:deep(h1), 
:deep(h2), 
:deep(input) {
    font-family: "Alumni Sans SC", sans-serif;
}

.auth-container {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    flex-direction: column;
    align-items: center;
    position: relative;
}

.header-bar {
    position: absolute;
    top: 0;
    left: 0;

    width: 100%;
    height: 8vh;
    
    display: flex;
    justify-content: center;
    align-items: center;

    background: transparent;
}

.header-bar a {
    text-decoration: none;
    color: var(--text-color);
    font-size: 32px;
    padding: 0;
}

.wrapper {
    --text-color: #D8D9DA;
    --placeholder-text: #646565;
    --box-color: #2e2e2e;
    --box-color-hover: #323232;
    --box-color-active: #767474;
    --anchor-color: #616bdd;
    --anchor-color-active: #424fdb;
    --invalid-pass: #a3333d;
    --valid-pass: #45cb85;

    background-color: #3a3a3a;

    font-family: "Alumni Sans SC", sans-serif;
    
    box-sizing: border-box;

    width: 80%;
    max-width: 380px;
    min-width: 270px;

    height: 70%;
    max-height: 710px;

    margin-top: 4vh;
    
    flex-grow: 1;
    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 16px;
}

.wrapper h1 {
    font-size: 2.5rem;
    font-weight: 400;
    line-height: 1.1;
    color: var(--text-color);
    
    padding: 0;

    margin: 0;
    margin-top: 0.5em;
    margin-bottom: 1em;
}

.wrapper .input-box {
    position: relative;
    width: 100%;
    margin-bottom: 1em;
}

.wrapper .input-box input {
    width: 100%;
    height: 2.5em;
    padding-left: 1em;
    padding-right: 2.5em;
    border-radius: 6px;
    border: none;
    background-color: var(--box-color);
    color: var(--input-color);
    font-size: 1em;
    box-sizing: border-box;
    outline: none;
}

.wrapper .input-box input:focus::placeholder {
    color: var(--input-color);
}

.wrapper .input-box:nth-of-type(1) i,
.wrapper .input-box:nth-of-type(2) i {
  cursor: default;
  pointer-events: none;
}

.wrapper .input-box i {
    position: absolute;
    right: 1em;
    top: 50%;
    transform: translateY(-50%);
    color: var(--input-color);
    cursor: pointer;
}
.wrapper .input-box input::placeholder {
    color: var(--placeholder-text);
}

.wrapper .btn {
    color: var(--text-color);
    background-color: var(--box-color);
    border-radius: 8px;
    border: 1px solid transparent;
    padding: 0.3em 0.8em 0.4em 0.8em;
    font-size: 1em;
    font-weight: bold;
    font-family: inherit;
    cursor: pointer;
    transition: border-color 0.25s;
}

.wrapper .btn:hover {
    background-color: var(--box-color-hover);
}

.wrapper .btn:focus {
    background-color: var(--box-color-active);
}

.wrapper .redirect-link {
    margin-top: 1em;
}

.wrapper .redirect-link a {
    color: var(--anchor-color);
}

.wrapper .redirect-link a:hover {
    color: var(--anchor-color-active);
}

.error-holder {
    padding: 0;
    min-height: 50px;
}

.password-criteria {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 0;
    margin: 1rem 0 1rem 0;
    font-size: 1rem;
}
.password-criteria p,
.password-criteria ul {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding-left: 2em;
    margin: 0;
    color: var(--text-color);
}

.valid-password {
    color: var(--valid-pass);
}

.invalid-password {
    color: var(--invalid-pass);
}

@media (max-width: 600px){
    .wrapper {
        height: 70%;
        max-height: 600px;
    }
    .password-criteria p,
    .password-criteria ul {
        font-size: 0.8rem;
    }
}

@media (max-height: 700px) {
    .wrapper {
        height: 70%;
        max-height: 590px;
    }
    .error-holder {
        padding: 0;
        min-height: 40px;
    }
}
</style>