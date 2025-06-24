<template>
    <div>
        <header class="header-bar">
            <nav class="nav-bar">
                <div class="header-logo">
                    <a href="/home">ReserveIt.com</a>
                </div>
            </nav>
        </header>
        <div class="wrapper">
            <form @submit.prevent="handleLogin">
                <h1>Sign In</h1>
                <div class="input-box">
                    <input type="text" placeholder="Username" required v-model="username">
                    <i class="bx bxs-user"></i>
                </div>
                <div class="input-box">
                    <input
                        :type="showPassword ? 'text' : 'password'"
                        placeholder="Password"
                        required
                        v-model="password"
                    />
                    <i
                        :class="showPassword ? 'bx bxs-show' : 'bx bxs-hide'"
                        @click="togglePassword"
                        style="cursor: pointer"
                    ></i>
                </div>

                <div class="forgot">
                    <a href="#"><i>Forgot password?</i></a>
                </div>

                <div class="error-holder">
                    <p v-if="error" style="color: #f44; font-size: 0.9em">*{{ error }}</p>
                </div>

                <button type="submit" class="btn">Login</button>

                <div class="register-link">
                    <p>Don't have an account? <a href="/signup"><i>Sign Up</i></a></p>
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
            error: '',
            showPassword: false
        }
    },
    methods: {
        togglePassword() {
            this.showPassword = !this.showPassword;
        },
        async handleLogin() {
            try {
                const response = await fetch('http://localhost:8080/login', {
                    method: "POST",
                    mode: "cors",
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        username: this.username,
                        password: this.password
                    })
                })

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const result = await response.json()
                if (result.success) {
                    this.error = '';
                    console.log('Login successful')
                    this.$router.push('/home');
                } else {
                    console.log('Wrong credentials')
                    this.error = "Wrong credentials.";
                }
            } catch (e) {
                console.error('Fetch error:', e);
                this.error = "Wrong credentials.";
            }
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

    font-family: "Alumni Sans SC", sans-serif;
    background-color: #3a3a3a;
    width: 380px;
    height: 520px;
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
    margin-top: 0.50em;
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
    margin-bottom: 0.5em;
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
    padding: 0.4em 0.8em 0.4em 0.8em;
    font-size: 1em;
    font-weight: bold;
    font-family: inherit;
    cursor: pointer;
    transition: border-color 0.25s;
    margin-top: 2em;
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

.wrapper .error-holder {
    padding: 0;
    min-height: 25px;
    margin: 0;
}

.wrapper .error-holder p {
    margin: 0;
}
</style>