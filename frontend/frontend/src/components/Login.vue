<template>
  <div class="wrapper">
    <form action="">
        <h1>Welcome!</h1>
        <h2>Sign in to your Account</h2>
        <div class="input-box">
            <input type="text" placeholder="Username" required>
            <i class="bx bxs-user"></i>
        </div>
        <div class="input-box">
            <input type="password" placeholder="Password" required>
            <i class="bx bxs-lock-alt"></i>
        </div>
        <div class="remember-forgot">
            <label><input type="checkbox">Remember me</label>
            <a href="#"><i>Forgot password?</i></a>
        </div>

        <button type="submit" class="btn">Login</button>

        <div class="register-link">
            <p>Don't have an account? <a href="#"><i>Register</i></a></p>
        </div>
    </form>
  </div>
</template>

<script>
export default {

}
</script>

<style scoped>
.wrapper {
    --text-color: #D8D9DA;
    --placeholder-text: #646565;
    --box-color: #2e2e2e;
    --box-color-hover: #323232;
    --box-color-active: #767474;
    --anchor-color: #616bdd;
    --anchor-color-active: #424fdb;

    background-color: #3a3a3a;
    width: 450px;
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
    margin-top: 1em;
    color: var(--text-color);
}

.wrapper h2 {
    font-size: 32px;
    padding: 0;
    margin-top: 0;
    margin-bottom: 1em;
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

.wrapper .input-box i {
    position: absolute;
    right: 1em;
    top: 50%;
    transform: translateY(-50%);
    color: var(--input-color);
    pointer-events: none;
}
.wrapper .input-box input::placeholder {
    color: var(--placeholder-text);
}

.wrapper .remember-forgot {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 4em;
}

.wrapper .remember-forgot label {
    display: flex;
    align-items: center;
    gap: 0.4em;
    color: var(--input-color);
}

.wrapper .remember-forgot a {
    color: var(--anchor-color);
}

.wrapper .remember-forgot a:hover {
    color: var(--anchor-color-active);
}

.wrapper .btn {
    color: var(--text-color);
    background-color: var(--box-color);
    border-radius: 8px;
    border: 1px solid transparent;
    padding: 0.4em 0.8em 0.6em 0.8em;
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

.wrapper .register-link {
    margin-top: 1em;
}

.wrapper .register-link a {
    color: var(--anchor-color);
}

.wrapper .register-link a:hover {
    color: var(--anchor-color-active);
}
</style>