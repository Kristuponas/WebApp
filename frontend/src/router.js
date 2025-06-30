import { createRouter, createWebHistory } from 'vue-router'

import Signin from './components/Signin.vue'
import Signup from './components/Signup.vue'
import Home from './components/Home.vue'
import Profile from './components/Profile.vue'
import ChangePass from './components/ChangePass.vue'

const routes = [
    { path: '/', redirect: '/home' },
    { path: '/home', component: Home},
    { path: '/signin', component: Signin },
    { path: '/signup', component: Signup },
    { path: '/profile', component: Profile },
    { path: '/changePassword', component: ChangePass }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router
