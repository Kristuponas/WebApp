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
                <!--
                <div class="header-buttons">
                    <template v-if="isLoggedIn">
                        <div class="header-button-group">
                            <a href="/profile">Profile</a>
                        </div>
                        <div class="header-button-group" @click="logout" style="cursor: pointer;">
                            <a href="#" @click.prevent="logout">Log Out</a>
                        </div> 
                    </template>
                   <template v-else>
                        <div class="header-button-group">
                            <a href="/signup">Sign Up</a>
                        </div>
                        <div class="header-button-group">
                            <a href="/signin">Sign In</a>
                        </div> 
                   </template>
                </div>
                -->
            </nav>
            <transition name="fade">
                <div v-if="menuOpen" class="dropdown-menu">
                    <button @click="$router.push('/profile')">Profile</button>
                    <button @click.prevent="logout">Log Out</button>
                </div>
            </transition>
        </header>
        <div class="wrapper">
            <div class="filter-bar">
                <input v-model="filters.city" placeholder="City..." />

                <select v-model="filters.roomType">
                    <option value="">All Types</option>
                    <option>Studio</option>
                    <option>Apartment</option>
                    <option>Single</option>
                </select>

                <input v-model.number="filters.maxPrice" type="number" placeholder="Max Price (€)" />

                <label>
                    <input type="checkbox" value="WiFi" v-model="filters.amenities" />
                    WiFi
                </label>
                <label>
                    <input type="checkbox" value="Kitchen" v-model="filters.amenities" />
                    Kitchen
                </label>

                <button @click="applyFilters">Apply</button>
            </div>

            <div class="room-listings">
                <div v-for="room in filteredRooms" :key="room.id" class="room-card">
                    <h3>{{ room.title }}</h3>
                    <p>{{ room.location.city }} - {{ room.price_per_night }}€</p>
                    <p>Type: {{ room.room_type }}</p>
                </div>
            </div>
        </div>
  </div>
  
</template>

<script>
export default {
    data() {
        return {
            isLoggedIn: false,
            menuOpen: false,
            roomListings: [],
            filters: {
                city: '',
                roomType: '',
                maxPrice: null,
                amenities: [],
            }
        }
    },
    mounted() {
        this.isLoggedIn = !!localStorage.getItem("token")
    },
    computed: {
    filteredRooms() {
        return this.roomListings.filter(room => {
            const cityMatch = this.filters.city === '' || room.location.city.toLowerCase().includes(this.filters.city.toLowerCase());
            const typeMatch = this.filters.roomType === '' || room.room_type === this.filters.roomType;
            const priceMatch = this.filters.maxPrice === null || room.price_per_night <= this.filters.maxPrice;
            const amenitiesMatch = this.filters.amenities.every(amenity => room.amenities.includes(amenity));
            return cityMatch && typeMatch && priceMatch && amenitiesMatch;
        });
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
        }
    }
}
</script>

<style scoped>
.auth-container {
    --text-color: #D8D9DA;
    --placeholder-text: #646565;
    --box-color: #2e2e2e;
    --box-color-darker: #272727;
    --box-color-hover: #323232;
    --box-color-active: #767474;
    --anchor-color: #616bdd;
    --anchor-color-active: #424fdb;

    height: 100vh;
    width: 100vw;
    padding-top: 10vh;
    padding-bottom: 0;

    display: flex;


    flex-direction: column;
    position: relative;
    overflow: hidden;
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
    width: 40%;
    text-align: left;
}

.header-logo a {
    margin-left: 3em;
    text-decoration: none;
    color: var(--text-color);
    font-size: 32px;
    padding: 0;
}

.header-buttons {
    width: 60%;
    box-sizing: border-box;
    justify-content: flex-end;
    display: flex;
    margin-right: 5em;
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
    overflow-y: auto;
    padding: 0;
    margin-top: 0;
    width: 100vw;
    box-sizing: border-box;

    
}

.filter-bar {
    position: sticky;
    top: 10vh;
    z-index: 500;

    background-color: #2E2E2E;

    padding: 1rem;
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
}

.room-listings {
    margin-top: 1rem;
    display: flex;
    flex-direction: column;
    gap: 2rem;
}

.room-card {
    background: var(--box-color);
    padding: 1rem;
    border-radius: 8px;
    color: var(--text-color);
}

</style>