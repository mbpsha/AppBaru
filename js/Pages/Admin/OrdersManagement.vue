<script setup>
import { ref } from 'vue'
import { useForm } from '@inertiajs/vue3'
import SidebarAdmin from '@/Components/Admin/SidebarAdmin.vue'
import HeaderAdmin from '@/Components/Admin/HeaderAdmin.vue'

const props = defineProps({
    orders: Object
})

const showDetailModal = ref(false)
const selectedOrder = ref(null)

const form = useForm({
    status: ''
})

function viewOrderDetail(order) {
    selectedOrder.value = order
    form.status = order.status
    showDetailModal.value = true
}

function closeModal() {
    showDetailModal.value = false
    selectedOrder.value = null
}

function updateStatus() {
    form.put(route('admin.orders.updateStatus', selectedOrder.value.id_order), {
        onSuccess: () => {
            closeModal()
        }
    })
}

function getStatusColor(status) {
    const colors = {
        'pending': 'bg-yellow-100 text-yellow-700',
        'diproses': 'bg-blue-100 text-blue-700',
        'dikirim': 'bg-purple-100 text-purple-700',
        'selesai': 'bg-green-100 text-green-700',
        'dibatalkan': 'bg-red-100 text-red-700'
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
                <h1 class="text-3xl font-bold text-gray-800">Orders Management</h1>
            </div>

            <!-- Orders Table -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden">
                <div class="p-4 border-b">
                    <h2 class="text-xl font-semibold text-gray-800">All Orders</h2>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Order ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr v-for="order in orders.data" :key="order.id_order" class="hover:bg-gray-50">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">#{{ order.id_order }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ order.user?.nama || 'N/A' }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ new Date(order.created_at).toLocaleDateString('id-ID') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">Rp {{ order.total_harga?.toLocaleString('id-ID') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span
                                        class="px-3 py-1 rounded-full text-xs font-semibold"
                                        :class="getStatusColor(order.status)"
                                    >
                                        {{ order.status }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <button @click="viewOrderDetail(order)" class="text-green-600 hover:text-green-900 flex items-center gap-1">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                                        </svg>
                                        View Details
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="px-6 py-4 border-t flex justify-between items-center">
                    <div class="text-sm text-gray-700">
                        Showing {{ orders.from }} to {{ orders.to }} of {{ orders.total }} entries
                    </div>
                    <div class="flex gap-2">
                        <button
                            v-for="link in orders.links"
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

        <!-- Order Detail Modal -->
        <div v-if="showDetailModal && selectedOrder" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg p-8 max-w-3xl w-full mx-4 max-h-[90vh] overflow-y-auto">
                <h2 class="text-2xl font-bold mb-6 text-gray-800">Order Details #{{ selectedOrder.id_order }}</h2>

                <!-- Customer Info -->
                <div class="mb-6 p-4 bg-gray-50 rounded-lg">
                    <h3 class="font-semibold text-lg mb-3 text-gray-800">Customer Information</h3>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm text-gray-600">Name</p>
                            <p class="font-medium">{{ selectedOrder.user?.nama }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Email</p>
                            <p class="font-medium">{{ selectedOrder.user?.email }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Phone</p>
                            <p class="font-medium">{{ selectedOrder.user?.no_telp || '-' }}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-600">Address</p>
                            <p class="font-medium">{{ selectedOrder.address?.alamat || 'N/A' }}</p>
                        </div>
                    </div>
                </div>

                <!-- Order Items -->
                <div class="mb-6">
                    <h3 class="font-semibold text-lg mb-3 text-gray-800">Order Items</h3>
                    <div class="border rounded-lg overflow-hidden">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Product</th>
                                    <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Price</th>
                                    <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Qty</th>
                                    <th class="px-4 py-2 text-left text-sm font-medium text-gray-600">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in selectedOrder.order_details" :key="item.id" class="border-t">
                                    <td class="px-4 py-3">{{ item.product?.nama_produk }}</td>
                                    <td class="px-4 py-3">Rp {{ item.harga?.toLocaleString('id-ID') }}</td>
                                    <td class="px-4 py-3">{{ item.jumlah }}</td>
                                    <td class="px-4 py-3 font-semibold">Rp {{ (item.harga * item.jumlah)?.toLocaleString('id-ID') }}</td>
                                </tr>
                            </tbody>
                            <tfoot class="bg-gray-50 border-t-2">
                                <tr>
                                    <td colspan="3" class="px-4 py-3 text-right font-semibold">Total:</td>
                                    <td class="px-4 py-3 font-bold text-lg text-green-600">Rp {{ selectedOrder.total_harga?.toLocaleString('id-ID') }}</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>

                <!-- Update Status -->
                <form @submit.prevent="updateStatus" class="mb-6">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Update Order Status</label>
                    <div class="flex gap-3">
                        <select v-model="form.status" class="flex-1 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500">
                            <option value="pending">Pending</option>
                            <option value="diproses">Diproses</option>
                            <option value="dikirim">Dikirim</option>
                            <option value="selesai">Selesai</option>
                            <option value="dibatalkan">Dibatalkan</option>
                        </select>
                        <button type="submit" :disabled="form.processing" class="px-6 py-2 bg-green-500 text-white rounded-md hover:bg-green-600">
                            {{ form.processing ? 'Updating...' : 'Update Status' }}
                        </button>
                    </div>
                </form>

                <div class="flex gap-3">
                    <button type="button" @click="closeModal" class="flex-1 bg-gray-300 text-gray-700 py-2 rounded-md hover:bg-gray-400">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>