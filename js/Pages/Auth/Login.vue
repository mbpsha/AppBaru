<script setup>
import { ref, reactive } from 'vue'
import axios from 'axios'
import { router } from '@inertiajs/vue3'

import Logo from '*/dashboard/logo-ngundur.png'
import Background from '*/login/BackgroundWOverlay.png'

const form = reactive({
    login: '',
    password: '',
    processing: false,
    errors: {}
})

const showPassword = ref(false)
const togglePassword = () => {
    showPassword.value = !showPassword.value
}

async function submit(e) {
    // Prevent any default form submission
    if (e) e.preventDefault()

    form.processing = true
    form.errors = {}

    try {
        // First, get CSRF cookie to ensure session is initialized
        await axios.get('/sanctum/csrf-cookie')

        const response = await axios.post('/api/login', {
            login: form.login,
            password: form.password
        }, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })

        // Store token in localStorage
        localStorage.setItem('auth_token', response.data.token)
        localStorage.setItem('user', JSON.stringify(response.data.user))

        // Set default axios header for future requests
        axios.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`

        // Force reload to ensure session is properly set
        const redirectUrl = response.data.redirect || (response.data.user.role === 'admin' ? '/admin/dashboard' : '/dashboard')
        window.location.href = redirectUrl
    } catch (error) {
        form.processing = false
        if (error.response?.data?.errors) {
            form.errors = error.response.data.errors
        } else if (error.response?.data?.message) {
            form.errors.login = error.response.data.message
        } else {
            form.errors.login = 'Login failed. Please try again.'
        }
        form.password = ''
    }
}
</script>

<template>
    <div class="relative min-h-screen overflow-hidden">
        <!-- Background Image -->
        <div class="absolute inset-0" :style="{ backgroundImage: `url(${Background})`, backgroundSize: 'cover', backgroundPosition: 'center' }"></div>

        <!-- Logo -->
        <div class="relative z-10 flex justify-center pt-16 pb-8">
            <img :src="Logo" alt="NGUNDUR Logo" class="w-auto h-16" />
        </div>

        <!-- Form Card -->
        <div class="relative z-10 flex justify-center px-4">
            <div class="w-full max-w-md p-8 shadow-lg rounded-xl" style="background-color: #BCD6B1;">
                <h1 class="mb-8 text-2xl font-semibold text-center text-white">Sign In</h1>

                <form @submit.prevent="submit" class="space-y-6">
                    <div>
                        <label class="block mb-2 text-sm font-medium text-white">Email or Username</label>
                        <input
                            v-model="form.login"
                            type="text"
                            required
                            placeholder="Enter your email or username"
                            class="w-full px-4 py-2 bg-white border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                            :class="{ 'border-red-500': form.errors.login }"
                        />
                        <div v-if="form.errors.login" class="mt-1 text-sm text-red-200">{{ form.errors.login }}</div>
                    </div>

                    <div>
                        <label class="block mb-2 text-sm font-medium text-white">Password</label>
                        <div class="relative">
                            <input
                                v-model="form.password"
                                :type="showPassword ? 'text' : 'password'"
                                required
                                placeholder="Enter your password"
                                class="w-full px-4 py-2 bg-white border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                                :class="{ 'border-red-500': form.errors.password }"
                            />
                                <button
                                        type="button"
                                        class="absolute inset-y-0 right-0 px-3 flex items-center text-gray-500 hover:text-gray-700"
                                        :aria-label="showPassword ? 'Hide password' : 'Show password'"
                                        @click="togglePassword"
                                    >
                                        <!-- eye -->
                                        <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M2.25 12s3.75-7.5 9.75-7.5 9.75 7.5 9.75 7.5-3.75 7.5-9.75 7.5S2.25 12 2.25 12z" />
                                            <circle cx="12" cy="12" r="3" stroke-width="2" stroke="currentColor" />
                                        </svg>
                                        <!-- eye-off -->
                                        <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M3 3l18 18M10.58 10.58A3 3 0 0113.5 13.5M6.1 6.1C3.9 7.9 2.25 12 2.25 12s3.75 7.5 9.75 7.5c2.02 0 3.82-.52 5.34-1.38M13.42 13.42C12.99 13.8 12.52 14 12 14a3 3 0 01-3-3c0-.52.2-.99.58-1.42M17.9 17.9C20.1 16.1 21.75 12 21.75 12s-3.75-7.5-9.75-7.5c-1.03 0-2.01.15-2.93.42" />
                                        </svg>
                                    </button>
                            </div>
                        <div v-if="form.errors.password" class="mt-1 text-sm text-red-600">{{ form.errors.password }}</div>
                    </div>

                    <button :disabled="form.processing" type="submit" class="w-full py-3 font-medium text-white transition-colors bg-blue-600 rounded-md hover:bg-blue-700 disabled:opacity-50">
                        {{ form.processing ? 'Signing in...' : 'Sign In' }}
                    </button>
                </form>

                <p class="mt-6 text-sm text-center text-white">
                    Don't Have an Account?
                    <a :href="route('register')" class="text-blue-200 underline">Sign Up</a>
                </p>
            </div>
        </div>
    </div>
</template>
