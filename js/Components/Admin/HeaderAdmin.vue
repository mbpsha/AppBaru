<script setup>
import { computed } from 'vue'
import { usePage, router } from '@inertiajs/vue3'
import axios from 'axios'
import Logo from '*/dashboard/logo-tandur.png'

const page = usePage()
const user = computed(() => page.props.auth.user)

const onLogout = async () => {
    try {
        // Clear tokens FIRST
        localStorage.removeItem('auth_token')
        localStorage.removeItem('user')
        delete axios.defaults.headers.common['Authorization']

        // Get CSRF cookie
        await axios.get('/sanctum/csrf-cookie')

        // Call logout API
        await axios.post('/api/logout', {}, {
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })

        // Wait for server to process
        await new Promise(resolve => setTimeout(resolve, 100))

        // Force full page reload to dashboard (public mode)
        window.location.replace('/dashboard')
    } catch (error) {
        console.error('Logout failed:', error)
        window.location.replace('/dashboard')
        window.location.replace('/dashboard')
        window.location.reload(true)
    }
}
</script>

<template>
    <header class="fixed top-0 right-0 h-16 shadow-md left-64 bg-gradient-to-r from-green-300 to-green-300 z-15">
        <div class="flex items-center justify-between h-full px-8">
            <div class="flex items-center gap-3">
                <img :src="Logo" alt="NGUNDUR" class="h-12" />
            </div>

            <div class="flex items-center gap-4 text-black">
                <span class="text-lg font-semibold">Admin</span>
                <div class="flex items-center gap-2 px-4 py-2 rounded-full bg-white/20">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                    </svg>
                    <span class="font-medium">{{ user?.nama || 'Admin' }}</span>
                </div>

                <!-- tombol logout -->
                <button @click="onLogout" class="px-3 py-1.5 rounded-md bg-white/20 hover:bg-red-300 text-black text-sm">
                    Log-out
                </button>
            </div>
        </div>
    </header>
</template>
