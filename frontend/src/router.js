import { createRouter, createWebHistory } from 'vue-router'

import Login from './components/Login.vue'
import Signup from './components/Signup.vue'
import Home from './components/Home.vue'

const routes = [
    { path: '/', redirect: '/home' },
    { path: '/home', component: Home},
    { path: '/login', component: Login },
    { path: '/signup', component: Signup }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router
