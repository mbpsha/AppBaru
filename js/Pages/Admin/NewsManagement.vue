<script setup>
import { ref, computed } from 'vue'
import { useForm, router } from '@inertiajs/vue3'
import SidebarAdmin from '@/Components/Admin/SidebarAdmin.vue'
import HeaderAdmin from '@/Components/Admin/HeaderAdmin.vue'

const props = defineProps({
    news: Object
})

// State untuk modal
const showModal = ref(false)
const isEdit = ref(false)
const selectedNews = ref(null)
const imagePreview = ref(null)

// Form untuk create/edit
const form = useForm({
    title: '',
    excerpt: '',
    content: '',
    image: null,
    is_published: true
})

// Open modal untuk create
function openCreateModal() {
    isEdit.value = false
    form.reset()
    form.clearErrors()
    imagePreview.value = null
    showModal.value = true
}

// Open modal untuk edit
function openEditModal(article) {
    isEdit.value = true
    selectedNews.value = article
    form.title = article.title
    form.excerpt = article.excerpt
    form.content = article.content
    form.is_published = article.is_published
    form.image = null // reset image input
    imagePreview.value = resolveImageUrl(article.image)
    showModal.value = true
}

// Close modal
function closeModal() {
    showModal.value = false
    form.reset()
    form.clearErrors()
    selectedNews.value = null
    imagePreview.value = null
}

// Handle image file
function handleFileChange(e) {
    const file = e.target.files?.[0] ?? null
    form.image = file

    if (!file) {
        if (isEdit.value && selectedNews.value?.image) {
            imagePreview.value = resolveImageUrl(selectedNews.value.image)
        } else {
            imagePreview.value = null
        }
        return
    }

    const reader = new FileReader()
    reader.onload = (event) => {
        imagePreview.value = event.target?.result ?? null
    }
    reader.readAsDataURL(file)
}

function resolveImageUrl(path) {
    if (!path) return null
    if (path.startsWith('http://') || path.startsWith('https://')) return path
    const normalized = path.replace(/^\/?storage\//, '')
    return `/storage/${normalized}`
}

// Submit form
function submitForm() {
    if (isEdit.value) {
        // Gunakan form.post dengan forceFormData untuk support file upload
        form.transform((data) => ({
            ...data,
            _method: 'PUT'
        })).post(route('admin.news.update', selectedNews.value.id), {
            preserveScroll: true,
            onSuccess: () => closeModal()
        })
    } else {
        form.post(route('admin.news.store'), {
            preserveScroll: true,
            onSuccess: () => closeModal()
        })
    }
}

// Delete news
function deleteNews(id) {
    if (confirm('Yakin ingin menghapus berita ini?')) {
        router.delete(route('admin.news.destroy', id), {
            preserveScroll: true
        })
    }
}

// Toggle published status
function togglePublished(article) {
    const formData = useForm({
        title: article.title,
        excerpt: article.excerpt,
        content: article.content,
        is_published: !article.is_published
    })

    formData.transform((data) => ({
        ...data,
        _method: 'PUT'
    })).post(route('admin.news.update', article.id), {
        preserveScroll: true
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
                <h1 class="text-3xl font-bold text-gray-800">News Management</h1>
                <button @click="openCreateModal" class="px-6 py-2 text-white transition-colors bg-green-500 rounded-lg hover:bg-green-600">
                    + Add News
                </button>
            </div>

            <!-- News Table -->
            <div class="overflow-hidden bg-white rounded-lg shadow-md">
                <table class="w-full">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Title</th>
                            <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Excerpt</th>
                            <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Status</th>
                            <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Date</th>
                            <th class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="article in news.data" :key="article.id" class="hover:bg-gray-50">
                            <td class="px-6 py-4">
                                <div class="font-medium text-gray-900">{{ article.title }}</div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="text-sm text-gray-500 line-clamp-2">{{ article.excerpt }}</div>
                            </td>
                            <td class="px-6 py-4">
                                <button @click="togglePublished(article)"
                                    class="px-3 py-1 text-xs font-medium rounded-full cursor-pointer"
                                    :class="article.is_published
                                        ? 'bg-green-100 text-green-700 hover:bg-green-200'
                                        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'">
                                    {{ article.is_published ? 'Published' : 'Draft' }}
                                </button>
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-500">
                                {{ new Date(article.created_at).toLocaleDateString('id-ID') }}
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex gap-2">
                                    <button @click="openEditModal(article)"
                                        class="px-3 py-1 text-sm text-white bg-blue-500 rounded hover:bg-blue-600">
                                        Edit
                                    </button>
                                    <button @click="deleteNews(article.id)"
                                        class="px-3 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600">
                                        Delete
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="!news.data || news.data.length === 0">
                            <td colspan="5" class="px-6 py-8 text-center text-gray-500">
                                Belum ada berita. Klik "Add News" untuk menambah berita baru.
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Pagination -->
                <div v-if="news.links && news.links.length > 3" class="flex items-center justify-between px-6 py-4 border-t bg-gray-50">
                    <div class="text-sm text-gray-500">
                        Showing {{ news.from }} to {{ news.to }} of {{ news.total }} entries
                    </div>
                    <div class="flex gap-2">
                        <a v-for="link in news.links" :key="link.label"
                           :href="link.url"
                           v-html="link.label"
                           class="px-3 py-1 border rounded"
                           :class="link.active
                               ? 'bg-green-500 text-white border-green-500'
                               : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'"
                           :disabled="!link.url">
                        </a>
                    </div>
                </div>
            </div>
        </main>

        <!-- Modal Create/Edit -->
        <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50" @click.self="closeModal">
            <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto m-4">
                <div class="sticky top-0 flex items-center justify-between px-6 py-4 bg-white border-b">
                    <h2 class="text-xl font-semibold">{{ isEdit ? 'Edit News' : 'Add News' }}</h2>
                    <button @click="closeModal" class="text-gray-400 hover:text-gray-600">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>
                </div>

                <form @submit.prevent="submitForm" class="p-6 space-y-4">
                    <!-- Title -->
                    <div>
                        <label class="block mb-1 text-sm font-medium text-gray-700">Title</label>
                        <input v-model="form.title" type="text" required
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent">
                        <p v-if="form.errors.title" class="mt-1 text-sm text-red-600">{{ form.errors.title }}</p>
                    </div>

                    <!-- Excerpt -->
                    <div>
                        <label class="block mb-1 text-sm font-medium text-gray-700">Excerpt (Ringkasan)</label>
                        <textarea v-model="form.excerpt" rows="2" required
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                            placeholder="Ringkasan singkat berita (max 500 karakter)"></textarea>
                        <p v-if="form.errors.excerpt" class="mt-1 text-sm text-red-600">{{ form.errors.excerpt }}</p>
                    </div>

                    <!-- Content -->
                    <div>
                        <label class="block mb-1 text-sm font-medium text-gray-700">Content (Isi Berita)</label>
                        <textarea v-model="form.content" rows="8" required
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                            placeholder="Tulis isi berita lengkap di sini..."></textarea>
                        <p v-if="form.errors.content" class="mt-1 text-sm text-red-600">{{ form.errors.content }}</p>
                    </div>

                    <!-- Image -->
                    <div>
                        <label class="block mb-1 text-sm font-medium text-gray-700">Image</label>
                        <input type="file" @change="handleFileChange" accept="image/*"
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                        <p class="mt-1 text-xs text-gray-500">{{ isEdit ? 'Leave blank to keep current image' : 'Upload gambar berita' }}</p>
                        <p v-if="form.errors.image" class="mt-1 text-sm text-red-600">{{ form.errors.image }}</p>
                        <div v-if="imagePreview" class="mt-4">
                            <span class="text-xs font-medium text-gray-600 uppercase">Preview</span>
                            <img :src="imagePreview" alt="Preview image"
                                class="object-cover w-full max-w-sm mt-2 border rounded-lg shadow-sm">
                            <p v-if="isEdit && !form.image" class="mt-1 text-xs text-gray-500">Menampilkan gambar yang tersimpan saat ini.</p>
                        </div>
                    </div>

                    <!-- Published Status -->
                    <div class="flex items-center gap-2">
                        <input v-model="form.is_published" type="checkbox" id="is_published"
                            class="w-4 h-4 text-green-600 border-gray-300 rounded focus:ring-green-500">
                        <label for="is_published" class="text-sm font-medium text-gray-700">Publish immediately</label>
                    </div>

                    <!-- Buttons -->
                    <div class="flex gap-3 pt-4">
                        <button type="submit" :disabled="form.processing"
                            class="flex-1 px-4 py-2 text-white bg-green-500 rounded-lg hover:bg-green-600 disabled:bg-gray-400">
                            {{ form.processing ? 'Saving...' : (isEdit ? 'Update' : 'Save') }}
                        </button>
                        <button type="button" @click="closeModal"
                            class="px-4 py-2 text-gray-700 bg-gray-200 rounded-lg hover:bg-gray-300">
                            Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>

<style scoped>
.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
</style>