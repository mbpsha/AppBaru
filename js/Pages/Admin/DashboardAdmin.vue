<script setup>
import { computed } from 'vue'
import SidebarAdmin from '@/Components/Admin/SidebarAdmin.vue'
import HeaderAdmin from '@/Components/Admin/HeaderAdmin.vue'

const props = defineProps({
    stats: Object,
    recentProducts: Array,
    recentUsers: Array,
    monthlySales: Array
})
</script>

<template>
    <div class="min-h-screen bg-gray-100">
        <SidebarAdmin />
        <HeaderAdmin />

        <!-- Main Content -->
        <main class="p-8 pt-16 ml-64">
            <div class="flex items-center justify-between mb-6">
                <h1 class="text-3xl font-bold text-gray-800">Dashboard</h1>
            </div>

            <!-- Stats Cards -->
            <div class="grid grid-cols-1 gap-6 mb-8 md:grid-cols-2 lg:grid-cols-4">
                <!-- Total Products -->
                <div class="p-6 bg-white border-l-4 border-green-500 rounded-lg shadow-md">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500 uppercase">Total Products</p>
                            <h3 class="mt-1 text-3xl font-bold text-gray-800">{{ stats?.totalProducts || 0 }}</h3>
                        </div>
                        <div class="p-3 bg-green-100 rounded-full">
                            <svg class="w-8 h-8 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M3 1a1 1 0 000 2h1.22l.305 1.222a.997.997 0 00.01.042l1.358 5.43-.893.892C3.74 11.846 4.632 14 6.414 14H15a1 1 0 000-2H6.414l1-1H14a1 1 0 00.894-.553l3-6A1 1 0 0017 3H6.28l-.31-1.243A1 1 0 005 1H3z"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Total Users -->
                <div class="p-6 bg-white border-l-4 border-green-500 rounded-lg shadow-md">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500 uppercase">Total Users</p>
                            <h3 class="mt-1 text-3xl font-bold text-gray-800">{{ stats?.totalUsers || 0 }}</h3>
                        </div>
                        <div class="p-3 bg-green-100 rounded-full">
                            <svg class="w-8 h-8 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Total Orders -->
                <div class="p-6 bg-white border-l-4 border-purple-500 rounded-lg shadow-md">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500 uppercase">Total Orders</p>
                            <h3 class="mt-1 text-3xl font-bold text-gray-800">{{ stats?.totalOrders || 0 }}</h3>
                        </div>
                        <div class="p-3 bg-purple-100 rounded-full">
                            <svg class="w-8 h-8 text-purple-500" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z"></path>
                                <path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5z" clip-rule="evenodd"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Pending Verification (Payments) -->
                <div class="p-6 bg-white border-l-4 border-yellow-500 rounded-lg shadow-md">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500 uppercase">Pending Verification</p>
                            <h3 class="mt-1 text-3xl font-bold text-gray-800">{{ stats?.pendingPayments || 0 }}</h3>
                        </div>
                        <div class="p-3 bg-yellow-100 rounded-full">
                            <svg class="w-8 h-8 text-yellow-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>

                <!-- Recent Products & Users -->
            <div class="grid grid-cols-1 gap-6 mb-8 lg:grid-cols-2">
                <!-- Recent Products -->
                <div class="p-6 bg-white rounded-lg shadow-md">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-xl font-semibold text-gray-800">Recent Products</h2>
                        <a :href="route('admin.products.index')" class="px-4 py-2 text-sm text-white bg-green-500 rounded hover:bg-green-600">
                            View All
                        </a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b">
                                    <th class="px-2 py-3 font-semibold text-left text-gray-600">Name</th>
                                    <th class="px-2 py-3 font-semibold text-left text-gray-600">Price</th>
                                    <th class="px-2 py-3 font-semibold text-left text-gray-600">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="product in recentProducts" :key="product.id" class="border-b hover:bg-gray-50">
                                    <td class="px-2 py-3">{{ product.nama_produk }}</td>
                                    <td class="px-2 py-3">Rp {{ product.harga?.toLocaleString('id-ID') }}</td>
                                    <td class="px-2 py-3">
                                        <span class="px-2 py-1 text-xs text-green-700 bg-green-100 rounded">Terverifikasi</span>
                                    </td>
                                </tr>
                                <tr v-if="!recentProducts || recentProducts.length === 0">
                                    <td colspan="3" class="py-4 text-center text-gray-500">No products yet</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Recent Users -->
                <div class="p-6 bg-white rounded-lg shadow-md">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-xl font-semibold text-gray-800">Recent Users</h2>
                        <a :href="route('admin.users.index')" class="px-4 py-2 text-sm text-white bg-green-500 rounded hover:bg-green-600">
                            View All
                        </a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b">
                                    <th class="px-2 py-3 font-semibold text-left text-gray-600">Name</th>
                                    <th class="px-2 py-3 font-semibold text-left text-gray-600">Email</th>
                                    <th class="px-2 py-3 font-semibold text-left text-gray-600">Role</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="user in recentUsers" :key="user.id" class="border-b hover:bg-gray-50">
                                    <td class="px-2 py-3">{{ user.nama }}</td>
                                    <td class="px-2 py-3">{{ user.email }}</td>
                                    <td class="px-2 py-3">
                                        <span
                                            class="px-2 py-1 text-xs rounded"
                                            :class="user.role === 'admin' ? 'bg-red-100 text-red-700' : 'bg-cyan-100 text-cyan-700'"
                                        >
                                            {{ user.role || 'Penjual' }}
                                        </span>
                                    </td>
                                </tr>
                                <tr v-if="!recentUsers || recentUsers.length === 0">
                                    <td colspan="3" class="py-4 text-center text-gray-500">No users yet</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Monthly Sales Chart -->
            <div class="p-6 bg-white rounded-lg shadow-md">
                <h2 class="mb-4 text-xl font-semibold text-gray-800">Monthly Sales Overview</h2>
                <div class="flex items-end justify-between h-64 gap-2">
                    <div v-for="(sale, index) in monthlySales" :key="index" class="flex flex-col items-center flex-1">
                        <div class="relative w-full transition-colors bg-green-500 rounded-t hover:bg-green-600 group"
                             :style="{ height: (sale.amount / Math.max(...monthlySales.map(s => s.amount)) * 100) + '%' }">
                            <div class="absolute px-2 py-1 text-xs text-white transition-opacity transform -translate-x-1/2 bg-gray-800 rounded opacity-0 -top-8 left-1/2 group-hover:opacity-100 whitespace-nowrap">
                                Rp {{ sale.amount?.toLocaleString('id-ID') }}
                            </div>
                        </div>
                        <span class="mt-2 text-xs text-gray-600">{{ sale.month }}</span>
                    </div>
                </div>
                <div class="flex items-center justify-center mt-4">
                    <div class="flex items-center gap-2">
                        <div class="w-4 h-4 bg-green-500 rounded"></div>
                        <span class="text-sm text-gray-600">Sales</span>
                    </div>
                </div>
            </div>
        </main>
    </div>
</template>