<script setup>
import { ref } from 'vue'
import { useForm } from '@inertiajs/vue3'
import SidebarAdmin from '@/Components/Admin/SidebarAdmin.vue'
import HeaderAdmin from '@/Components/Admin/HeaderAdmin.vue'

const props = defineProps({
    payments: Object
})

const showDetailModal = ref(false)
const selectedPayment = ref(null)

const form = useForm({
    status: ''
})

function viewPaymentDetail(payment) {
    selectedPayment.value = payment
    form.status = payment.status
    showDetailModal.value = true
}

function closeModal() {
    showDetailModal.value = false
    selectedPayment.value = null
}

function verifyPayment(status) {
    form.status = status
    form.put(route('admin.payments.verify', selectedPayment.value.id_payment), {
        onSuccess: () => {
            closeModal()
        }
    })
}

function getStatusColor(status) {
    const colors = {
        'pending': 'bg-yellow-100 text-yellow-700',
        'verified': 'bg-green-100 text-green-700',
        'rejected': 'bg-red-100 text-red-700'
    }
    return colors[status] || 'bg-gray-100 text-gray-700'
}
</script>

<template>
    <div class="min-h-screen bg-gray-100">
        <SidebarAdmin />
        <HeaderAdmin />

        <!-- Main Content -->
        <main class="ml-64 pt-16 p-8">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-3xl font-bold text-gray-800">Payment Verification</h1>
            </div>

            <!-- Payments Table -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden">
                <div class="p-4 border-b">
                    <h2 class="text-xl font-semibold text-gray-800">Pending Payments</h2>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Payment ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Order ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Amount</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Method</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr v-for="payment in payments.data" :key="payment.id_payment" class="hover:bg-gray-50">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">#{{ payment.id_payment }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">#{{ payment.id_order }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ payment.order?.user?.nama || 'N/A' }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">Rp {{ payment.jumlah?.toLocaleString('id-ID') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ payment.metode_pembayaran }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ new Date(payment.created_at).toLocaleDateString('id-ID') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span
                                        class="px-3 py-1 rounded-full text-xs font-semibold"
                                        :class="getStatusColor(payment.status)"
                                    >
                                        {{ payment.status }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <button @click="viewPaymentDetail(payment)" class="text-green-600 hover:text-green-900 flex items-center gap-1">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                                        </svg>
                                        Verify
                                    </button>
                                </td>
                            </tr>
                            <tr v-if="!payments.data || payments.data.length === 0">
                                <td colspan="8" class="px-6 py-8 text-center text-gray-500">
                                    No pending payments
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="px-6 py-4 border-t flex justify-between items-center">
                    <div class="text-sm text-gray-700">
                        Showing {{ payments.from }} to {{ payments.to }} of {{ payments.total }} entries
                    </div>
                    <div class="flex gap-2">
                        <button
                            v-for="link in payments.links"
                            :key="link.label"
                            @click="$inertia.visit(link.url)"
                            :disabled="!link.url"
                            class="px-3 py-1 rounded"
                            :class="link.active ? 'bg-green-500 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'"
                            v-html="link.label"
                        ></button>
                    </div>
                </div>
            </div>
        </main>

        <!-- Payment Detail Modal -->
        <div v-if="showDetailModal && selectedPayment" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg p-8 max-w-3xl w-full mx-4 max-h-[90vh] overflow-y-auto">
                <h2 class="text-2xl font-bold mb-6 text-gray-800">Payment Verification #{{ selectedPayment.id_payment }}</h2>

                <!-- Payment Info -->
                <div class="mb-6 p-4 bg-gray-50 rounded-lg">
                    <h3 class="font-semibold text-lg mb-3 text-gray-800">Payment Information</h3>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm text-gray-600">Order ID</p>
                            <p class="font-medium">#{{ selectedPayment.id_order }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Customer</p>
                            <p class="font-medium">{{ selectedPayment.order?.user?.nama }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Payment Method</p>
                            <p class="font-medium">{{ selectedPayment.metode_pembayaran }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Amount</p>
                            <p class="font-medium text-green-600">Rp {{ selectedPayment.jumlah?.toLocaleString('id-ID') }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Payment Date</p>
                            <p class="font-medium">{{ new Date(selectedPayment.created_at).toLocaleString('id-ID') }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Shipping</p>
                            <p class="font-medium">
                                {{ selectedPayment.order?.shipping_courier
                                    ? `${selectedPayment.order.shipping_courier} ${selectedPayment.order.shipping_service || ''}`
                                    : 'Belum dihitung' }}
                            </p>
                            <p v-if="selectedPayment.order?.shipping_cost" class="text-xs text-gray-500">
                                Ongkir: Rp {{ selectedPayment.order.shipping_cost?.toLocaleString('id-ID') }}
                                <span v-if="selectedPayment.order?.shipping_etd">• ETD {{ selectedPayment.order.shipping_etd }} hari</span>
                            </p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Status</p>
                            <span
                                class="px-3 py-1 rounded-full text-xs font-semibold inline-block"
                                :class="getStatusColor(selectedPayment.status)"
                            >
                                {{ selectedPayment.status }}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Proof of Transfer -->
                <div class="mb-6">
                    <h3 class="font-semibold text-lg mb-3 text-gray-800">Proof of Transfer</h3>
                    <div class="border rounded-lg p-4 bg-gray-50">
                        <img
                            v-if="selectedPayment.bukti_transfer"
                            :src="selectedPayment.bukti_transfer"
                            alt="Proof of Transfer"
                            class="w-full max-h-96 object-contain rounded"
                        >
                        <p v-else class="text-gray-500 text-center py-8">No proof of transfer uploaded</p>
                    </div>
                </div>

                <!-- Order Details -->
                <div class="mb-6">
                    <h3 class="font-semibold text-lg mb-3 text-gray-800">Order Details</h3>
                    <div class="border rounded-lg overflow-hidden">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Product</th>
                                    <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Qty</th>
                                    <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Price</th>
                                    <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in selectedPayment.order?.order_details" :key="item.id" class="border-t">
                                    <td class="px-4 py-3">{{ item.product?.nama_produk }}</td>
                                    <td class="px-4 py-3">{{ item.jumlah }}</td>
                                    <td class="px-4 py-3">Rp {{ item.harga?.toLocaleString('id-ID') }}</td>
                                    <td class="px-4 py-3 font-semibold">Rp {{ (item.harga * item.jumlah)?.toLocaleString('id-ID') }}</td>
                                </tr>
                            </tbody>
                            <tfoot class="bg-gray-50 border-t-2">
                                <tr>
                                    <td colspan="3" class="px-4 py-3 text-right font-semibold">Total:</td>
                                    <td class="px-4 py-3 font-bold text-lg text-green-600">Rp {{ selectedPayment.order?.total_harga?.toLocaleString('id-ID') }}</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>

                <!-- Verification Actions -->
                <div v-if="selectedPayment.status === 'pending'" class="flex gap-3 mb-4">
                    <button
                        @click="verifyPayment('verified')"
                        :disabled="form.processing"
                        class="flex-1 bg-green-500 text-white py-3 rounded-md hover:bg-green-600 font-semibold flex items-center justify-center gap-2"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                        </svg>
                        {{ form.processing ? 'Processing...' : 'Approve Payment' }}
                    </button>
                    <button
                        @click="verifyPayment('rejected')"
                        :disabled="form.processing"
                        class="flex-1 bg-red-500 text-white py-3 rounded-md hover:bg-red-600 font-semibold flex items-center justify-center gap-2"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                        {{ form.processing ? 'Processing...' : 'Reject Payment' }}
                    </button>
                </div>

                <button type="button" @click="closeModal" class="w-full bg-gray-300 text-gray-700 py-2 rounded-md hover:bg-gray-400">
                    Close
                </button>
            </div>
        </div>
    </div>
</template>