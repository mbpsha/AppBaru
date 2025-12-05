<script setup>
import { ref } from 'vue'
import { useForm, usePage, router } from '@inertiajs/vue3'   
import SidebarAdmin from '@/Components/Admin/SidebarAdmin.vue'
import HeaderAdmin from '@/Components/Admin/HeaderAdmin.vue'

const props = defineProps({
  users: { type: Object, required: true }
})

const page = usePage()

// === NEW: state filter & sort (ambil default dari query props kalau dikirim backend) ===
const search = ref(page.props.filters?.search ?? '')
const sortBy = ref(page.props.filters?.sortBy ?? 'nama')   // nama | email | role | created_at
const sortDir = ref(page.props.filters?.sortDir ?? 'asc')   // asc | desc

let searchTimer = null
function onSearchInput() {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => applyFilters(), 400) // debounce
}
function toggleSortDir() {
  sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc'
  applyFilters()
}
function applyFilters(url = null) {
  const params = {
    search: search.value || undefined,
    sortBy: sortBy.value || undefined,
    sortDir: sortDir.value || undefined
  }
  if (url) {
    router.get(url, params, { preserveState: true, preserveScroll: true, replace: true })
  } else {
    router.get(route('admin.users.index'), params, { preserveState: true, preserveScroll: true, replace: true })
  }
}
// === END NEW ===

const showModal = ref(false)
const editMode = ref(false)
const selectedUser = ref(null)

const form = useForm({
  nama: '',
  username: '',
  email: '',
  no_telp: '',
  alamat: '',
  role: 'user',
  password: ''
})

function openCreateModal() {
  editMode.value = false
  selectedUser.value = null
  form.reset()
  form.role = 'user'
  showModal.value = true
}

function openEditModal(user) {
  editMode.value = true
  selectedUser.value = user
  form.nama = user.nama || ''
  form.username = user.username || ''
  form.email = user.email || ''
  form.no_telp = user.no_telp || ''
  form.alamat = user.alamat || ''
  form.role = user.role || 'user'
  form.password = ''
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  form.reset()
  selectedUser.value = null
}

function submitForm() {
  if (editMode.value && selectedUser.value) {
    form.put(route('admin.users.update', selectedUser.value.id_user), {
      preserveScroll: true,
      onSuccess: () => closeModal()
    })
  } else {
    form.post(route('admin.users.store'), {
      preserveScroll: true,
      onSuccess: () => closeModal()
    })
  }
}

function deleteUser(id) {
  if (confirm('Hapus pengguna ini?')) {
    form.delete(route('admin.users.destroy', id), { preserveScroll: true })
  }
}

const roleBadgeClass = (role) =>
  role === 'admin'
    ? 'bg-red-100 text-red-700'
    : 'bg-blue-100 text-blue-700'
</script>

<template>
  <div class="min-h-screen bg-gray-100">
    <SidebarAdmin />
    <HeaderAdmin />

    <main class="ml-64 pt-16 p-6">
      <!-- Banner judul -->
      <div class="rounded-2xl border border-green-200 bg-green-50 px-6 py-5 mb-6">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <h1 class="text-2xl font-bold text-gray-800">Pengguna</h1>

          <!-- NEW: Search + Sort controls -->
          <div class="flex flex-wrap items-center gap-3">
            <div class="relative">
              <input
                v-model="search"
                @input="onSearchInput"
                type="text"
                placeholder="Cari nama/username/email…"
                class="w-64 md:w-72 rounded-md border px-9 py-2"
              />
              <svg class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35M10 18a8 8 0 100-16 8 8 0 000 16z"/>
              </svg>
            </div>

            <select v-model="sortBy" @change="applyFilters()" class="rounded-md border px-3 py-2">
              <option value="nama">Nama</option>
              <option value="email">Email</option>
              <option value="role">Role</option>
              <option value="created_at">Terbaru</option>
            </select>

            <button @click="toggleSortDir" class="px-3 py-2 rounded-md border text-gray-700 hover:bg-gray-50">
              {{ sortDir === 'asc' ? 'A-Z ↑' : 'Z-A ↓' }}
            </button>

            <button @click="openCreateModal"
                    class="inline-flex items-center gap-2 px-4 py-2 rounded-md bg-blue-600 text-white text-sm hover:bg-blue-700">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
              </svg>
              Tambahkan Pengguna
            </button>
          </div>
          <!-- END NEW -->
        </div>
      </div>

      <!-- Tabel pengguna -->
      <div class="bg-white rounded-xl shadow border">
        <div class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead>
              <tr class="text-left bg-gray-50 text-gray-600">
                <th class="px-6 py-3 font-semibold">
                  <button @click="sortBy='nama'; toggleSortDir()" class="flex items-center gap-1">
                    Nama
                    <span v-if="sortBy==='nama'">{{ sortDir==='asc' ? '↑' : '↓' }}</span>
                  </button>
                </th>
                <th class="px-6 py-3 font-semibold">
                  <button @click="sortBy='email'; toggleSortDir()" class="flex items-center gap-1">
                    Email
                    <span v-if="sortBy==='email'">{{ sortDir==='asc' ? '↑' : '↓' }}</span>
                  </button>
                </th>
                <th class="px-6 py-3 font-semibold">
                  <button @click="sortBy='role'; toggleSortDir()" class="flex items-center gap-1">
                    Role
                    <span v-if="sortBy==='role'">{{ sortDir==='asc' ? '↑' : '↓' }}</span>
                  </button>
                </th>
                <th class="px-6 py-3 font-semibold text-center">Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="u in users.data" :key="u.id_user" class="border-t hover:bg-gray-50/60">
                <td class="px-6 py-4">{{ u.nama }}</td>
                <td class="px-6 py-4 text-gray-600">{{ u.email }}</td>
                <td class="px-6 py-4">
                  <span class="px-3 py-1 rounded-full text-xs font-semibold" :class="roleBadgeClass(u.role)">
                    {{ u.role === 'admin' ? 'Admin' : 'Pengguna' }}
                  </span>
                </td>
                <td class="px-6 py-3">
                  <div class="flex justify-center gap-2">
                    <button @click="openEditModal(u)" class="p-2 rounded-md border border-green-200 text-green-600 hover:bg-green-50"
                            title="Edit">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                      </svg>
                    </button>
                    <button @click="deleteUser(u.id_user)" class="p-2 rounded-md border border-red-200 text-red-600 hover:bg-red-50"
                            title="Hapus">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                      </svg>
                    </button>
                  </div>
                </td>
              </tr>

              <tr v-if="!users.data?.length">
                <td colspan="4" class="px-6 py-10 text-center text-gray-500">Belum ada pengguna.</td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div class="px-6 py-4 border-t flex justify-between items-center text-sm">
          <div class="text-gray-600">
            Menampilkan {{ users.from || 0 }}–{{ users.to || 0 }} dari {{ users.total || 0 }} data
          </div>
          <div class="flex gap-2">
            <!-- NEW: gunakan applyFilters agar query tetap terbawa -->
            <button v-for="link in users.links" :key="link.label"
                    @click="link.url && applyFilters(link.url)"
                    :disabled="!link.url"
                    class="px-3 py-1 rounded"
                    :class="link.active ? 'bg-green-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'"
                    v-html="link.label" />
          </div>
        </div>
      </div>
    </main>

    <!-- Modal Tambah/Edit -->
    <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
      <div class="w-full max-w-lg bg-white rounded-xl shadow-lg">
        <div class="px-6 py-4 border-b flex items-center justify-between">
          <h2 class="text-lg font-semibold">
            {{ editMode ? 'Edit Pengguna' : 'Tambahkan Pengguna' }}
          </h2>
          <button @click="closeModal" class="p-2 rounded hover:bg-gray-100">
            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <form @submit.prevent="submitForm" class="px-6 py-5 space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-xs text-gray-600 mb-1">Nama</label>
              <input v-model="form.nama" type="text" required class="w-full rounded-md border px-3 py-2">
              <p v-if="form.errors.nama" class="text-xs text-red-600 mt-1">{{ form.errors.nama }}</p>
            </div>
            <div>
              <label class="block text-xs text-gray-600 mb-1">Username</label>
              <input v-model="form.username" type="text" required class="w-full rounded-md border px-3 py-2">
              <p v-if="form.errors.username" class="text-xs text-red-600 mt-1">{{ form.errors.username }}</p>
            </div>
            <div>
              <label class="block text-xs text-gray-600 mb-1">Email</label>
              <input v-model="form.email" type="email" required class="w-full rounded-md border px-3 py-2">
              <p v-if="form.errors.email" class="text-xs text-red-600 mt-1">{{ form.errors.email }}</p>
            </div>
            <div>
              <label class="block text-xs text-gray-600 mb-1">No. Telepon</label>
              <input v-model="form.no_telp" type="text" class="w-full rounded-md border px-3 py-2">
              <p v-if="form.errors.no_telp" class="text-xs text-red-600 mt-1">{{ form.errors.no_telp }}</p>
            </div>
            <div class="md:col-span-2">
              <label class="block text-xs text-gray-600 mb-1">Alamat</label>
              <input v-model="form.alamat" type="text" class="w-full rounded-md border px-3 py-2">
              <p v-if="form.errors.alamat" class="text-xs text-red-600 mt-1">{{ form.errors.alamat }}</p>
            </div>
            <div>
              <label class="block text-xs text-gray-600 mb-1">Role</label>
              <select v-model="form.role" class="w-full rounded-md border px-3 py-2">
                <option value="user">Pengguna</option>
                <option value="admin">Admin</option>
              </select>
              <p v-if="form.errors.role" class="text-xs text-red-600 mt-1">{{ form.errors.role }}</p>
            </div>
            <div>
              <label class="block text-xs text-gray-600 mb-1">
                Password {{ editMode ? '(kosongkan jika tidak diubah)' : '' }}
              </label>
              <input v-model="form.password" :required="!editMode" type="password" class="w-full rounded-md border px-3 py-2">
              <p v-if="form.errors.password" class="text-xs text-red-600 mt-1">{{ form.errors.password }}</p>
            </div>
          </div>

          <div class="mt-2 flex justify-end gap-3">
            <button type="button" @click="closeModal" class="px-4 py-2 rounded-md bg-gray-200 text-gray-700 hover:bg-gray-300">
              Batal
            </button>
            <button type="submit" :disabled="form.processing"
                    class="px-4 py-2 rounded-md bg-green-600 text-white hover:bg-green-700 disabled:opacity-60">
              {{ form.processing ? 'Menyimpan...' : 'Simpan' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>