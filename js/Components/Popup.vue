<script setup>
import { ref, watch, onMounted } from 'vue'
import { usePage } from '@inertiajs/vue3'

const page = usePage()
const show = ref(false)
const popup = ref(null)

// Watch for popup flash messages
watch(() => page.props.flash?.popup, (value) => {
    if (value) {
        popup.value = value
        show.value = true

        // Auto-hide after 5 seconds
        setTimeout(() => {
            show.value = false
        }, 5000)
    }
}, { immediate: true })

// Check on mount
onMounted(() => {
    if (page.props.flash?.popup) {
        popup.value = page.props.flash.popup
        show.value = true

        setTimeout(() => {
            show.value = false
        }, 5000)
    }
})

function close() {
    show.value = false
}

function getIcon() {
    switch (popup.value?.type) {
        case 'success':
            return `<svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
            </svg>`
        case 'error':
            return `<svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>`
        case 'warning':
            return `<svg class="w-6 h-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
            </svg>`
        case 'info':
        default:
            return `<svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>`
    }
}

function getStyles() {
    switch (popup.value?.type) {
        case 'success':
            return 'bg-green-50 border-green-200'
        case 'error':
            return 'bg-red-50 border-red-200'
        case 'warning':
            return 'bg-yellow-50 border-yellow-200'
        case 'info':
        default:
            return 'bg-blue-50 border-blue-200'
    }
}
</script>

<template>
    <Transition name="popup">
        <div v-if="show && popup"
             class="fixed top-4 right-4 z-50 w-full max-w-md">
            <div :class="['flex items-start gap-3 p-4 rounded-lg shadow-xl border-2', getStyles()]">
                <!-- Icon -->
                <div v-html="getIcon()" class="flex-shrink-0 mt-0.5"></div>

                <!-- Message -->
                <div class="flex-1 pt-0.5">
                    <p class="text-sm font-medium text-gray-900">
                        {{ popup.message }}
                    </p>
                </div>

                <!-- Close Button -->
                <button @click="close"
                        class="flex-shrink-0 p-1 text-gray-400 transition rounded hover:bg-white hover:text-gray-600">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
        </div>
    </Transition>
</template>

<style scoped>
.popup-enter-active,
.popup-leave-active {
    transition: all 0.3s ease;
}

.popup-enter-from {
    opacity: 0;
    transform: translateX(100px);
}

.popup-leave-to {
    opacity: 0;
    transform: translateY(-20px);
}
</style>
