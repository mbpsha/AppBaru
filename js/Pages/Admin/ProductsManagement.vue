<script setup>
import { ref, computed } from 'vue'
import { useForm } from '@inertiajs/vue3'
import SidebarAdmin from '@/Components/Admin/SidebarAdmin.vue'
import HeaderAdmin from '@/Components/Admin/HeaderAdmin.vue'

const props = defineProps({
  products: Object,
  product: { type: Object, default: null } // jika edit single lewat controller
})

const showModal = ref(false)
const editMode = ref(false)
const selectedProduct = ref(null)
const imagePreview = ref(null)

const form = useForm({
    id: null,
    nama_produk: '',
    deskripsi: '',
    harga: '',
    stok: '',
    gambar: null,
    gambar_existing: ''
})

// WAJIB terisi (sesuaikan)
const requiredFields = ['nama_produk','deskripsi','harga','stok']
const isFormComplete = computed(() =>
  requiredFields.every(f => {
    const v = form[f]
    return v !== null && v !== '' && !(typeof v === 'number' && isNaN(v))
  })
)

function openCreateModal() {
  editMode.value = false
  selectedProduct.value = null
  form.reset()
  imagePreview.value = null
  showModal.value = true
}

function openEditModal(product) {
  editMode.value = true
  selectedProduct.value = product

  form.id              = product.id_produk
  form.nama_produk     = product.nama_produk
  form.deskripsi       = product.deskripsi
  form.harga           = typeof product.harga === 'number'
    ? product.harga
    : normalizeNumber(product.harga)
  form.stok            = product.stok
  form.gambar          = null
  form.gambar_existing = product.gambar || ''

  imagePreview.value   = product.gambar || null

  showModal.value = true
}

function closeModal() {
  showModal.value = false
}

function handleFileUpload(e) {
  const file = e.target.files?.[0] || null
  form.gambar = file
  if (file) {
    const reader = new FileReader()
    reader.onload = (ev) => { imagePreview.value = ev.target.result }
    reader.readAsDataURL(file)
  } else {
    // kembali ke gambar lama jika batal
    imagePreview.value = form.gambar_existing || null
  }
}

function normalizeNumber(value) {
  if (value === null || value === undefined) return value
  if (typeof value === 'number') return value

  const raw = String(value).replace(/\s+/g, '')
  if (raw === '') return value

  let normalized = raw

  if (raw.includes(',')) {
    // Indonesian style (2.500,00) -> strip thousand dot, swap comma to decimal point
    normalized = raw.replace(/\./g, '').replace(',', '.')
  } else if (raw.includes('.')) {
    // Detect thousand separator using dot when no comma present,
    // e.g. "2.500" or "1.000.000"
    const parts = raw.split('.')
    const lastSegment = parts[parts.length - 1]
    const looksLikeThousands =
      lastSegment.length === 3 && parts.slice(0, -1).every(seg => seg.length <= 3)

    if (looksLikeThousands) {
      normalized = raw.replace(/\./g, '')
    }
  }

  const parsed = Number(normalized)
  return Number.isFinite(parsed) ? parsed : value
}

function prepareNumericFields() {
  form.harga = normalizeNumber(form.harga)
  const stokParsed = parseInt(form.stok ?? 0, 10)
  form.stok = Number.isFinite(stokParsed) ? Math.max(0, stokParsed) : 0
}

function submitForm() {
  if (!isFormComplete.value) return

  prepareNumericFields()

  if (editMode.value) {
    form
      .transform(data => ({
        ...data,
        _method: 'PUT'
      }))
      .post(route('admin.products.update', selectedProduct.value.id_produk), {
        forceFormData: true,
        onSuccess: () => {
          showModal.value = false
        },
        onFinish: () => {
          form.transform(data => data)
        }
      })
  } else {
    form.post(route('admin.products.store'), {
      forceFormData: true,
      onSuccess: () => {
        showModal.value = false
      }
    })
  }
}

function deleteProduct(id) {
  if (!confirm('Hapus produk ini?')) return
  form.delete(route('admin.products.destroy', { id: id }), {
    onSuccess: () => {}
  })
}
</script>

<template>
    <div class="min-h-screen bg-gray-100">
        <SidebarAdmin />
        <HeaderAdmin />

        <!-- Main Content -->
        <main class="p-8 pt-16 ml-64">
            <div class="flex items-center justify-between mb-6">
                <h1 class="text-3xl font-bold text-gray-800">Products Management</h1>
                <button @click="openCreateModal" class="flex items-center gap-2 px-4 py-2 text-white bg-green-500 rounded-lg hover:bg-green-600">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                    </svg>
                    Add New Product
                </button>
            </div>

            <!-- Products Table -->
            <div class="overflow-hidden bg-white rounded-lg shadow-md">
                <div class="p-4 border-b">
                    <h2 class="text-xl font-semibold text-gray-800">All Products</h2>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">ID</th>
                                <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Image</th>
                                <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Name</th>
                                <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Price</th>
                                <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Stock</th>
                                <th class="px-6 py-3 text-xs font-medium tracking-wider text-center text-gray-500 uppercase">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <tr v-for="product in products.data" :key="product.id_produk" class="hover:bg-gray-50">
                                <td class="px-6 py-4 text-sm text-gray-900 whitespace-nowrap">{{ product.id_produk }}</td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <img :src="product.gambar || '/assets/dashboard/profil.png'" alt="Product" class="object-cover w-12 h-12 rounded">
                                </td>
                                <td class="px-6 py-4 text-sm font-medium text-gray-900">{{ product.nama_produk }}</td>
                                <td class="px-6 py-4 text-sm text-gray-900 whitespace-nowrap">Rp {{ product.harga?.toLocaleString('id-ID') }}</td>
                                <td class="px-6 py-4 text-sm text-gray-900 whitespace-nowrap">{{ product.stok }} unit</td>
                                <!-- Actions -->
                                <td class="px-6 py-4 text-sm font-medium whitespace-nowrap">
                                    <div class="flex items-center justify-center gap-4">
                                        <button @click="openEditModal(product)" class="text-green-600 hover:text-green-900" aria-label="Edit">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                            </svg>
                                        </button>
                                        <button @click="deleteProduct(product.id_produk)" class="text-red-600 hover:text-red-900" aria-label="Delete">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                            </svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>

        <!-- Modal -->
        <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
            <div class="w-full max-w-lg p-6 bg-white rounded-xl shadow">
              <h2 class="mb-4 text-lg font-semibold">
                {{ editMode ? 'Edit Produk' : 'Tambah Produk' }}
              </h2>

              <form @submit.prevent="submitForm" class="space-y-4">
                <div>
                  <label class="text-xs font-medium">Nama Produk</label>
                  <input v-model="form.nama_produk" type="text" class="w-full mt-1 border rounded px-3 py-2 text-sm" required>
                </div>
                <div>
                  <label class="text-xs font-medium">Deskripsi</label>
                    <textarea v-model="form.deskripsi" class="w-full mt-1 border rounded px-3 py-2 text-sm" rows="3" required />
                </div>
                <div class="grid grid-cols-3 gap-3">
                  <div>
                    <label class="text-xs font-medium">Harga</label>
                    <input v-model="form.harga" type="number" min="0" class="w-full mt-1 border rounded px-3 py-2 text-sm" required>
                  </div>
                  <div>
                    <label class="text-xs font-medium">Stok</label>
                    <input v-model="form.stok" type="number" min="0" class="w-full mt-1 border rounded px-3 py-2 text-sm" required>
                  </div>
                </div>

                <div>
                  <label class="text-xs font-medium">Gambar Produk</label>
                  <input type="file" accept="image/*" @change="handleFileUpload"
                         class="w-full mt-1 border rounded px-3 py-2 text-sm">
                  <input type="hidden" :value="form.gambar_existing" name="gambar_existing">
                  <div v-if="imagePreview" class="mt-3">
                    <img :src="imagePreview" class="object-cover w-40 h-40 border rounded" alt="Preview">
                    <p v-if="!form.gambar" class="mt-1 text-[11px] text-gray-500">
                    </p>
                  </div>
                </div>

                    <div class="flex justify-end gap-3 pt-2">
                        <button type="button" @click="closeModal"
                                class="px-4 py-2 text-sm rounded border bg-white hover:bg-gray-50">
                            Batal
                        </button>

                        <button type="submit"
                                :disabled="form.processing || !isFormComplete"
                                class="px-5 py-2 text-sm font-medium text-white rounded
                                        bg-green-600 hover:bg-green-700
                                        disabled:opacity-50 disabled:cursor-not-allowed">
                            {{ editMode ? 'Simpan Perubahan' : 'Simpan' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>