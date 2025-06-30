<template>
    <div class="auth-container">
        <header class="header-bar">
            <nav class="nav-bar">
                <div class="header-logo">
                    <a href="/home">ReserveIt.com</a>
                </div>
                <div class="menu">
                    <i class='bx bx-menu' @click="extendMenu"></i>
                </div>
            </nav>

            <transition name="fade">
                <div v-if="menuOpen" class="dropdown-menu">
                    <button @click="$router.push('/profile')">Profile</button>
                    <button @click.prevent="logout">Log Out</button>
                </div>
            </transition>
        </header>
        <div class="wrapper">
            <div class="user-info-title">
                <h2>User Info</h2>
            </div>
            <div class="user-info">
                <div class="param-title">
                    <p>Username</p>
                </div>
                <div class="param-info">
                    <p> {{ username }}</p>
                    <i class="bx bxs-user"></i>
                </div>

                <div class="param-title">
                    <p>Email</p>
                </div>
                <div class="param-info">
                    <p> {{ email }}</p>
                    <i class="bx bxs-envelope"></i>
                </div>

                <div class="param-title">
                    <p>Password</p>
                </div>
                <div class="param-info">
                    <p v-if="showPassword">{{ password }}</p>
                    <p v-else>{{ '*'.repeat(password.length) }}</p>
                    <i 
                        :class="showPassword ? 'bx bxs-show' : 'bx bxs-hide'"
                        @click="togglePassword"
                        style="cursor: pointer"
                    ></i>
                </div>
                <div class="change-password">
                    <a href="/changePassword">Change Password</a>
                </div>
            </div>
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
            menuOpen: false,
            showPassword: false
        }
    },
    async mounted() {
        const token = localStorage.getItem("token")
        if (!token) {
            this.$router.push("/signin")
            return
        }

        try {
            const response = await fetch("http://localhost:8080/profile", {
                method: "GET",
                headers: {
                    "Authorization": token
                }
            })

            const result = await response.json()
            if (result.success) {
                this.username = result.username
                this.email = result.email
                this.password = result.password
            } else {
                this.$router.push("/signin")
            }
        } catch (err) {
            console.error("Error fetching profile: ", err)
            this.$router.push("/signin")
        }
    },
    methods: {
        logout() {
            localStorage.removeItem("token")
            this.isLoggedIn = false
            this.$router.push("/signin")
        },
        extendMenu() {
            this.menuOpen = !this.menuOpen;
        },
        logout() {
            localStorage.removeItem("token")
            this.isLoggedIn = false
            this.$router.push("/signin")
        },
        togglePassword() {
            this.showPassword = !this.showPassword;
        },
    }
}
</script>

<style>
.auth-container {
    --text-color: #D8D9DA;
    --placeholder-text: #646565;
    --box-color: #2e2e2e;
    --box-color-darker: #272727;
    --box-color-hover: #323232;
    --box-color-active: #767474;
    --anchor-color: #616bdd;
    --anchor-color-active: #424fdb;

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
    background-color: #2E2E2E;
    position: fixed;
    display: block;
    box-sizing: border-box;
    z-index: 1000;
    width: 100vw;
    height: 10vh;
    top: 0;
    left: 0;
    margin: 0;
}

.nav-bar {
    box-sizing: border-box;
    justify-content: space-between;
    align-items: center;
    display: flex;
    height: 100%;
    z-index: auto;
}

.header-logo {
    width: 70vw;
    text-align: left;
}

.header-logo a {
    text-decoration: none;
    color: var(--text-color);
    font-size: 3rem;
    padding: 0;
    margin-left: 3vw;
}

.menu {
    width: 30vw;

    display: flex;
    justify-content: flex-end;
    align-items: flex-end;

    margin: 0;
    padding: 0;
}

.menu i {
    color: var(--input-color);
    font-size: 3.5rem;

    padding-right: 2vw;
    margin: 0;

    cursor: pointer;
}

.dropdown-menu {
    position: fixed;
    top: 10vh;
    right: 0;

    background-color: #2E2E2E;
    width: 100vw;
    height: 90vh;
    z-index: 1001;
    
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.dropdown-menu button {
    font-size: 1.5rem;
    font-weight: 500;
    font-family: inherit;
    color: var(--text-color);

    background-color: var(--box-color-darker);

    border-radius: 8px;
    border: 1px solid transparent;

    height: 6.5vh;
    padding: 0 1.2rem 0 1.2rem;
    margin-top: 1.2rem;    
    
    cursor: pointer;
}

.fade-enter-active, .fade-leave-active {
    transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
    opacity: 0;
}
.fade-enter-to, .fade-leave-from {
    opacity: 1;
}

.header-buttons {
    width: 50vw;
    box-sizing: border-box;
    justify-content: flex-end;
    display: flex;
}

.header-button-group {
    height: 40px;
    width: 80px;
    background: var(--box-color);
    margin-left: 10px;
    border-radius: 5px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.header-button-group:hover {
    background: var(--box-color-hover);
}

.header-button-group:focus {
    background: var(--box-color-active);
}

.header-buttons a, span {
    width: 100%;
    height: 100%;
    font-size: 24px;
    padding-top: 3px;
    color: var(--text-color);
}

.wrapper {
    display: flex;
    justify-content: flex-start;
    align-items: flex-start;
    flex-direction: column;

    width: 80vw;
    height: 80vh;

    padding: 0;
    margin-top: 5vh;
}

.user-info-title h2 {
    color: var(--text-color);

    padding-left: 2rem;
    font-size: 2rem;
    margin: 1rem 0 1rem 0;
}

.user-info {
    color: var(--text-color);

    display: flex;
    justify-content: flex-start;
    align-items: center;
    flex-direction: column;

    width: 100%;
}

.param-title p {
    margin: 0;
    font-size: 1.2rem;
}

.param-info p {
    padding-left: 1rem;
    margin: 0;
    font-size: 1.2rem;
}

.param-title {
    width: 80%;
    display: flex;
}

.param-info {
    position: relative;
    z-index: auto;
    
    width: 80%;
    height: 5.5vh;
    margin-bottom: 1rem;

    display: flex;
    justify-content: flex-start;
    align-items: center;
    position: relative;

    background-color: var(--box-color);

    outline: none;
    border: none;
    border-radius: 6px;
}

.user-info > .param-info:nth-child(6) {
    margin-bottom: 0;
}

.param-info i {
    color: var(--input-color);

    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    font-size: 1.2rem;
    
    cursor: default;
}

.change-password {
    margin: 0;
    padding: 0;
    width: 80%;

    display: flex;
    justify-content: flex-start;
}

.change-password a {
    font-size: 1.1rem;
    color: var(--anchor-color);
    margin-top: 0.3rem;
}

.change-password a:hover {
    color: var(--anchor-color-active);
}
</style>