<template>
    <div class="auth-container">
        <header class="header-bar">
            <a href="/home">ReserveIt.com</a>
        </header>
        <div class="wrapper">
            <form @submit.prevent="handleLogin" class="form-box">
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
                    <p v-if="error" style="color: var(--invalid-pass); font-size: 0.9em">*{{ error }}</p>
                </div>

                <button type="submit" class="btn">Sign In</button>

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
                const response = await fetch('http://localhost:8080/signin', {
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
                    localStorage.setItem("token", result.token)
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
    background-color: #3a3a3a;

    font-family: "Alumni Sans SC", sans-serif;
    
    box-sizing: border-box;

    width: 80%;
    max-width: 600px;

    height: 70%;
    max-height: 750px;

    margin-top: 4vh;
    
    flex-grow: 1;
    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 16px;
}

.form-box {
    width: 80%;
}

.wrapper h1 {
    font-size: 5rem;
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
    font-size: 1em;
    color: var(--input-color);

    box-sizing: border-box;
    width: 100%;
    height: 2.5em;

    padding-left: 1em;
    padding-right: 2.5em;
    
    background-color: var(--box-color);
    
    outline: none;
    border: none;
    border-radius: 6px;
}
.wrapper .input-box input:focus::placeholder {
    color: var(--input-color);
}

.wrapper .input-box:first-of-type i {
    cursor: default;
    pointer-events: none;
}

.wrapper .input-box i {
    color: var(--input-color);

    position: absolute;
    right: 1em;
    top: 50%;
    transform: translateY(-50%);
    
    cursor: pointer;
}
.wrapper .input-box input::placeholder {
    color: var(--placeholder-text);
}

.wrapper .forgot {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.wrapper .forgot a {
    color: var(--anchor-color);
}

.wrapper .forgot a:hover {
    color: var(--anchor-color-active);
}

.wrapper .btn {
    font-size: 1rem;
    font-weight: 500;
    font-family: inherit;
    color: var(--text-color);

    background-color: var(--box-color);

    border-radius: 8px;
    border: 1px solid transparent;

    padding: 0.4em 0.8em 0.4em 0.8em;
    margin-top: 2em;    
    
    cursor: pointer;
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

@media (max-width: 600px){
    .wrapper {
        height: 70%;
        max-height: 600px;
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