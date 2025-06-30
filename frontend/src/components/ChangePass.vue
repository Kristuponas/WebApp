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
            <form @submit.prevent="handlePasswordChange" class="change-info">
                <h1>Change Password</h1>
                <div class="input-box">
                    <input
                        :type="show.password ? 'text' : 'password'"
                        placeholder="Current Password"
                        required
                        v-model="currentPass"
                    />
                    <i
                        :class="show.password ? 'bx bxs-show' : 'bx bxs-hide'"
                        @click="toggle('password')"
                    ></i>
                </div>
                <div class="input-box">
                    <input
                        :type="show.nPassword ? 'text' : 'password'"
                        placeholder="New Password"
                        required
                        v-model="newPass"
                    />
                    <i
                        :class="show.nPassword ? 'bx bxs-show' : 'bx bxs-hide'"
                        @click="toggle('nPassword')"
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
                        :type="show.cPassword ? 'text' : 'password'"
                        placeholder="Confirm Password"
                        required
                        v-model="newPassConfirm"
                    />
                    <i
                        :class="show.cPassword ? 'bx bxs-show' : 'bx bxs-hide'"
                        @click="toggle('cPassword')"
                    ></i>
                </div>
                <div class="error-holder">
                    <p v-if="error" style="color: var(--invalid-pass)">*{{ error }}</p>
                </div>
                <button type="submit">Save Password</button>
            </form>
        </div>
  </div>
    
</template>

<script>
export default {
    data() {
        return {
            password: '',
            currentPass: '',
            newPass: '',
            newPassConfirm: '',
            error: '',
            menuOpen: false,
            showPassword: false,
            show: {
                password: false,    // Current password
                nPassword: false,   // New password
                cPassword: false    // Confirm password
            },
            isMinLength: false,
            hasUppercase: false,
            hasLowercase: false,
            hasDigit: false,
            hasSpecial: false
        }
    },
    async mounted() {
        const token = localStorage.getItem("token")
        if (!token) {
            this.$router.push("/signin")
            return
        }

        try {
            const response = await fetch("http://localhost:8080/changePassword", {
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
        toggle(field) {
            this.show[field] = !this.show[field];
        },
        async handlePasswordChange() {
            this.error = '';
            // Check if current password matches
            if (this.currentPass !== this.password) {
                this.error = "Current password is incorrect.";
                return;
            }

            // Check if new password matches confirmed password
            if (this.newPass !== this.newPassConfirm) {
                this.error = "New passwords do not match.";
                return;
            }

            // Check if new password does not match current password
            if (this.currentPass == this.newPass) {
                this.error = "New password matches current password.";
                return;
            }

            // Check password criteria
            if(!this.isMinLength || !this.hasUppercase || !this.hasLowercase || !this.hasDigit || !this.hasSpecial) {
                this.error = "Password does not match criteria."
                return;
            }

            const token = localStorage.getItem("token");
            try {
                const response = await fetch("http://localhost:8080/changePassword", {
                    method: "POST",

                    headers: {
                        "Authorization": token,
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        newPassword: this.newPass
                    })
                });

                const result = await response.json();
                if (result.success) {
                    this.$router.push("/profile");
                } else {
                    this.error = "Failed to change password.";
                }
            } catch (err) {
                this.error = "Server error."
            }
        }
    },
    watch: {
        newPass(value) {
            this.isMinLength = value.length >= 8;
            this.hasUppercase = /[A-Z]/.test(value);
            this.hasLowercase = /[a-z]/.test(value);
            this.hasDigit = /\d/.test(value);
            this.hasSpecial = /[!@#$%^&*(),.?'"{}|<>:;\[\]\\\\-_=+]/.test(value);
        }
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
    --invalid-pass: #a3333d;
    --valid-pass: #45cb85;

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

.change-info {
    width: 100%;
    height: 100%;

    display: flex;
    justify-content: center;
    align-items: center;

    flex-direction: column;
}

.input-box {
    position: relative;
    width: 100%;
    margin-bottom: 1em;
}

.input-box input {
    font-size: 1.2rem;
    font-family: inherit;
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

.input-box input:focus {
    box-shadow: inset 1px 1px 6px rgba(0, 0, 0, 0.2),
                inset -1px -1px 6px rgba(255, 255, 255, 0.02);
    transition: box-shadow 0.3s ease;
}

.input-box input:focus::placeholder {
    color: var(--input-color);
}

.input-box i {
    color: var(--input-color);

    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    font-size: 1.2rem;
    
    cursor: pointer;
}

.input-box input::placeholder {
    color: var(--placeholder-text);
}

.password-criteria {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 0;
    margin: 1rem 0 2rem 0.5rem;
    font-size: 1rem;
}

.password-criteria p,
.password-criteria ul {
    display: flex;
    flex-direction: column;
    align-items: flex-start;

    color: var(--text-color);
    font-size: 1.1rem;
    
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

.wrapper button {
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

.wrapper button:hover {
    background-color: var(--box-color-hover);
}

.wrapper button:focus {
    background-color: var(--box-color-active);
}

.error-holder {
    padding: 0;
    margin: 0;

    height: 2rem;
}

.error-holder p {
    font-size: 1.1rem;
    margin: 0;
}

</style>