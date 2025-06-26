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
                    <p v-if="error" style="color: var(--invalid-pass)">*{{ error }}</p>
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
    background-color: #3a3a3a;

    box-sizing: border-box;

    width: 80vw;
    height: 70vh;
    
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

    margin-top: 3rem;
    margin-bottom: 2.5rem;
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
    height: 3rem;

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
    font-size: 1.2rem;
    
    cursor: pointer;
}

.wrapper .input-box input::placeholder {
    color: var(--placeholder-text);
}

.wrapper .forgot {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
}

.wrapper .forgot a {
    color: var(--anchor-color);
    font-size: 1.2rem;
}

.wrapper .forgot a:hover {
    color: var(--anchor-color-active);
}

.wrapper .btn {
    font-size: 1.2rem;
    font-weight: 400;
    font-family: inherit;
    color: var(--text-color);

    background-color: var(--box-color);

    border-radius: 8px;
    border: 1px solid transparent;

    padding: 0.4em 0.8em 0.4em 0.8em;
    margin-top: 1.2rem;    
    
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
    font-size: 1.2rem;
}

.wrapper .register-link a {
    color: var(--anchor-color);
}

.wrapper .register-link a:hover {
    color: var(--anchor-color-active);
}

.wrapper .error-holder {
    padding: 0;
    margin: 0;

    height: 2rem;
}

.wrapper .error-holder p {
    font-size: 1.1rem;
}

/* MOBILE VERSION (LARGER) */
@media only screen and (min-width: 600px) and (max-width: 767px) {
    .header-bar a {
        font-size: 3.5rem;
    }

    .form-box {
        width: 80%;
    }

    .wrapper {
        width: 80vw;
        height: 75vh;
    }

    .wrapper h1 {
        font-size: 4.5rem;
    }

    .wrapper .input-box input {
        font-size: 1.5rem;

        height: 4rem;
    }

    .wrapper .input-box i {
        font-size: 1.5rem;
    }

    .wrapper .forgot a {
        font-size: 1.5rem;
    }

    .wrapper .btn {
        margin-top: 1.5rem;
        font-size: 1.5rem;
    }

    .wrapper .register-link {
        font-size: 1.5rem;
    }

    .wrapper .error-holder {
        height: 2.5rem;
    }

    .wrapper .error-holder p {
        font-size: 1.3rem;
    }
}

@media only screen and (min-width: 768px) and (max-width: 991px){
    .header-bar a {
        font-size: 3.7rem;
    }

    .form-box {
        width: 80%;
    }

    .wrapper {
        width: 80vw;
        height: 75vh;
    }

    .wrapper h1 {
        font-size: 4.7rem;
    }

    .wrapper .input-box input {
        font-size: 1.7rem;

        height: 4.2rem;
    }

    .wrapper .input-box i {
        font-size: 1.7rem;
    }

    .wrapper .forgot a {
        font-size: 1.7rem;
    }

    .wrapper .btn {
        margin-top: 1.7rem;
        font-size: 1.7rem;
    }

    .wrapper .register-link {
        font-size: 1.7rem;
    }

    .wrapper .error-holder {
        height: 2.7rem;
    }

    .wrapper .error-holder p {
        font-size: 1.5rem;
    }
}

@media  only screen and (min-width: 992px) and (max-width: 1199px){
    .header-bar a {
        font-size: 4rem;
    }

    .form-box {
        width: 80%;
    }

    .wrapper {
        width: 70vw;
        height: 70vh;
    }

    .wrapper h1 {
        font-size: 5rem;
    }

    .wrapper .input-box input {
        font-size: 2rem;

        height: 4.5rem;
    }

    .wrapper .input-box i {
        font-size: 2rem;
    }

    .wrapper .forgot a {
        font-size: 2rem;
    }

    .wrapper .btn {
        margin-top: 2rem;
        font-size: 2rem;
    }

    .wrapper .register-link {
        font-size: 2rem;
    }

    .wrapper .error-holder {
        height: 3rem;
    }

    .wrapper .error-holder p {
        font-size: 1.8rem;
    }
}

@media only screen and (min-width: 1200px) {
    .header-bar a {
        font-size: 4rem;
    }

    .form-box {
        width: 80%;
    }

    .wrapper {
        width: 25vw;
        height: 70vh;
    }

    .wrapper h1 {
        font-size: 5rem;
    }

    .wrapper .input-box input {
        font-size: 2rem;

        height: 4.5rem;
    }

    .wrapper .input-box i {
        font-size: 2rem;
    }

    .wrapper .forgot a {
        font-size: 2rem;
    }

    .wrapper .btn {
        margin-top: 2rem;
        font-size: 2rem;
    }

    .wrapper .register-link {
        font-size: 2rem;
    }

    .wrapper .error-holder {
        height: 3rem;
    }

    .wrapper .error-holder p {
        font-size: 1.8rem;
    }
}

</style>