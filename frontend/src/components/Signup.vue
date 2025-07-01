<template>
    <div class="auth-container">
        <header class="header-bar">
            <a href="/home">ReserveIt.com</a>
        </header>
        <div class="wrapper">
            <form @submit.prevent="handleSignup" class="form-box">
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

                <div class="input-box confirm-password-box">
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
                    <p v-if="error" style="color: var(--invalid-pass)">*{{ error }}</p>
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
    height: 85vh;
    padding-top: 10vh;
    padding-bottom: 5vh;

    display: flex;
    justify-content: center;
    align-items: center;

    flex-direction: column;
    position: relative;
}

.header-bar {
    position: absolute;
    top: 0;
    left: 0;

    width: 100%;
    height: 10vh;
    
    display: flex;
    justify-content: center;
    align-items: center;

    background: transparent;
}

.header-bar a {
    text-decoration: none;
    color: var(--text-color);
    font-size: 3rem;
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

    box-sizing: border-box;

    width: 85vw;
    height: 80vh;
    
    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 16px;
    box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
}

.form-box {
    width: 70%;
}

.wrapper h1 {
    font-size: 4rem;
    font-weight: 400;
    line-height: 1.1;
    color: var(--text-color);
    
    padding: 0;

    margin-top: 1rem;
    margin-bottom: 1rem;
}

.wrapper .input-box {
    position: relative;
    width: 100%;
    margin-bottom: 1em;
}

.wrapper .input-box input {
    font-size: 1.2rem;
    color: var(--input-color);

    box-sizing: border-box;
    width: 100%;
    height: 5.5vh;

    padding-left: 1em;
    padding-right: 2.5em;
    
    background-color: var(--box-color);
    
    outline: none;
    border: none;
    border-radius: 6px;
}

.wrapper .input-box input:focus {
    box-shadow: inset 1px 1px 6px rgba(0, 0, 0, 0.2),
                inset -1px -1px 6px rgba(255, 255, 255, 0.02);
    transition: box-shadow 0.3s ease;
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
    color: var(--input-color);

    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    font-size: 1.2rem;
    
    cursor: pointer;
}

.wrapper .input-box input::placeholder {
    color: var(--placeholder-text);
}

.wrapper .confirm-password-box {
    margin-bottom: 1.5rem;
}

.wrapper .btn {
    font-size: 1.2rem;
    font-weight: 400;
    font-family: inherit;
    color: var(--text-color);

    background-color: var(--box-color);

    border-radius: 8px;
    border: 1px solid transparent;

    height: 5.5vh;
    padding: 0 1rem 0 1rem;
    margin-top: 1.5rem;    
    
    cursor: pointer;
}

.wrapper .btn:hover {
    background-color: var(--box-color-hover);
}

.wrapper .btn:focus {
    background-color: var(--box-color-active);
}

.wrapper .redirect-link {
    margin-top: 1rem;
    font-size: 1.2rem;
}

.wrapper .redirect-link a {
    color: var(--anchor-color);
}

.wrapper .redirect-link a:hover {
    color: var(--anchor-color-active);
}

.wrapper .error-holder {
    padding: 0;
    margin: 0;

    height: 2rem;
}

.wrapper .error-holder p {
    font-size: 1.1rem;
    margin: 0;
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

    color: var(--text-color);
    font-size: 0.9rem;
    
    margin: 0;
    padding-left: 0;
    list-style: none;
}

.valid-password {
    color: var(--valid-pass);
}

.invalid-password {
    color: var(--invalid-pass);
}

/* REALLY SMALL MOBILES */
@media only screen and (max-width: 400px) {
    .auth-container {
        height: 90vh;
        padding-top: 10vh;
        padding-bottom: 0vh;
    }
    
    .wrapper {
        margin-top: 0;
        height: 85vh;
    }

    .header-bar a {
        font-size: 2.5rem;
    }

    .wrapper h1 {
        font-size: 3.5rem;
    }

    .wrapper .input-box,
    .wrapper .btn {
        height: 5vh;
    }

    .wrapper .btn {
        padding: 0 1rem 0 1rem;
    }

    .wrapper .input-box {
        margin-bottom: 0.5rem;
    }

    .wrapper .input-box input {
        height: 5vh;
    }

    .wrapper .confirm-password-box {
        margin-bottom: 1.5rem;
    }

    .wrapper .input-box i,
    .wrapper .input-box input,
    .wrapper .btn,
    .wrapper .redirect-link {
        font-size: 1rem;
    }

    .password-criteria p,
    .password-criteria ul {
        font-size: 0.8rem;
    }

    .wrapper .error-holder p {
        font-size: 0.9rem;
    }
}

/* MOBILE VERSION (LARGER) */
@media only screen and (min-width: 600px) and (max-width: 767px) {
    .auth-container {
        height: 90vh;
        padding-top: 10vh;
        padding-bottom: 0vh;
    }
    
    .header-bar a {
        font-size: 3.5rem;
    }

    .form-box {
        width: 80%;
    }

    .wrapper {
        margin-top: 0;
        width: 80vw;
        height: 86vh;
    }

    .wrapper h1 {
        font-size: 4rem;
    }

    .wrapper .input-box input,
    .wrapper .btn {
        height: 6vh;
    }

    .wrapper .input-box i {
        right: 1.2rem;
    }

    .wrapper .btn {
        padding: 0 1rem 0 1rem;
    }

    .wrapper .input-box {
        margin-bottom: 1rem;
    }

    .wrapper .input-box i,
    .wrapper .input-box input,
    .wrapper .forgot a,
    .wrapper .btn,
    .wrapper .redirect-link {
        font-size: 1.2rem;
    }

    .password-criteria p,
    .password-criteria ul {
        font-size: 1.1rem;
    }

    .wrapper .error-holder {
        height: 1.7rem;
    }

    .wrapper .error-holder p {
        font-size: 1.1rem;
    }
}

/* TABLETS */
@media only screen and (min-width: 768px) and (max-width: 991px) {
    .auth-container {
        height: 90vh;
        padding-top: 10vh;
        padding-bottom: 0vh;
    }
    
    .header-bar a {
        font-size: 3.7rem;
    }

    .form-box {
        width: 80%;
    }

    .wrapper {
        margin-top: 0;
        width: 80vw;
        height: 86vh;
    }

    .wrapper h1 {
        font-size: 4rem;
    }

    .wrapper .input-box input,
    .wrapper .btn {
        height: 6vh;
    }

    .wrapper .input-box i {
        right: 1.4rem;
    }

    .wrapper .btn {
        padding: 0 1rem 0 1rem;
    }

    .wrapper .input-box {
        margin-bottom: 1rem;
    }

    .wrapper .input-box i,
    .wrapper .input-box input,
    .wrapper .forgot a,
    .wrapper .btn,
    .wrapper .redirect-link {
        font-size: 1.4rem;
    }

    .password-criteria p,
    .password-criteria ul {
        font-size: 1.3rem;
    }

    .wrapper .error-holder {
        height: 1.7rem;
    }

    .wrapper .error-holder p {
        font-size: 1.3rem;
    }
}

/* SMALL LAPTOPS / OLDER DISPLAYS */
@media only screen and (min-width: 992px) and (max-width: 1199px) {
    .auth-container {
        height: 90vh;
        padding-top: 10vh;
        padding-bottom: 0vh;
    }
    
    .header-bar a {
        font-size: 4rem;
    }

    .form-box {
        width: 80%;
    }

    .wrapper {
        margin-top: 0;
        width: 80vw;
        height: 87vh;
    }

    .wrapper h1 {
        font-size: 4.5rem;
    }

    .wrapper .input-box input,
    .wrapper .btn {
        height: 6vh;
    }

    .wrapper .input-box i {
        right: 1.6rem;
    }

    .wrapper .btn {
        padding: 0 1.5rem 0 1.5rem;
    }

    .wrapper .input-box {
        margin-bottom: 1.2rem;
    }

    .wrapper .input-box i,
    .wrapper .input-box input,
    .wrapper .forgot a,
    .wrapper .btn,
    .wrapper .redirect-link {
        font-size: 1.5rem;
    }

    .password-criteria p,
    .password-criteria ul {
        font-size: 1.2rem;
    }

    .wrapper .error-holder {
        height: 1.7rem;
    }

    .wrapper .error-holder p {
        font-size: 1.3rem;
    }
}
</style>