.<template>
    <div>
        <header class="header-bar">
            <nav class="nav-bar">
                <div class="header-logo">
                    <a href="/home">ReserveIt.com</a>
                </div>
            </nav>
        </header>
        <div class="wrapper">
            <form @submit.prevent="handleSignup">
                <h1>Sign Up</h1>
                <div class="input-box">
                    <input type="text" placeholder="Username" required v-model="username">
                    <i class="bx bxs-user"></i>
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

                <div class="register-link">
                    <p>Already have an Account? <a href="/login"><i>Sign In</i></a></p>
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
                    password: this.password
                })
            });

            const result = await response.json();

            if (!response.ok || !result.success) {
                this.error = result.message || "Signup failed";
            } else {
                console.log("Signup success:", result.message);
                this.$router.push("/login");
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

.header-bar {
    width: 250px;
    height: 50px;
    background: transparent;
}

.nav-bar {
    height: 100%;
    display: flex;
    align-items: center;
}

.header-logo a {
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
    --valid-pass: #45cb85;
    --invalid-pass: #a3333d;
    /*f64740*/

    font-family: "Alumni Sans SC", sans-serif;
    background-color: #3a3a3a;
    width: 380px;
    height: 700px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 16px;
}

.wrapper h1 {
    font-size: 42px;
    line-height: 1.1;
    padding: 0;
    margin: 0;
    margin-top: 0.5em;
    margin-bottom: 1em;
    font-weight: 400;
    color: var(--text-color);
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

.wrapper .input-box:first-of-type i {
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

.wrapper .forgot {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 4em;
}

.wrapper .forgot label {
    display: flex;
    align-items: center;
    gap: 0.4em;
    color: var(--input-color);
}

.wrapper .forgot a {
    color: var(--anchor-color);
}

.wrapper .forgot a:hover {
    color: var(--anchor-color-active);
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
    margin-top: 1em;
    transition: border-color 0.25s;
}

.wrapper .btn:hover {
    background-color: var(--box-color-hover);
}

.wrapper .btn:focus {
    background-color: var(--box-color-active);
}

.wrapper .register-link {
    margin-top: 1em;
}

.wrapper .register-link a {
    color: var(--anchor-color);
}

.wrapper .register-link a:hover {
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
    margin: 2em 0 2em 0;
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

</style>