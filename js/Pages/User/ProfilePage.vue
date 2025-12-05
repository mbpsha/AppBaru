<script setup>
import { useForm, usePage, router } from '@inertiajs/vue3'
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'

const page = usePage()
const checkoutIntent = page.props.checkoutIntent
const needAddress = page.props.needAddress
const user = page.props.user ?? page.props.auth?.user ?? {}

const form = useForm({
  nama: user.nama || '',
  username: user.username || '',
  email: user.email || '',
  no_telp: user.no_telp || '',
  alamat: user.alamat || '',
  checkout_return: checkoutIntent ? 1 : 0,
  checkout_product_id: checkoutIntent?.id_produk || null,
  checkout_qty: checkoutIntent?.qty || 1,
})

function onPhoneInput(e){ form.no_telp = (e.target.value || '').replace(/\D+/g,'') }
function save(){
  form.no_telp = (form.no_telp || '').replace(/\D+/g,'')
  form.put(route('profile.update'), { preserveScroll: true })
}

// Tombol kembali: pakai history jika ada, fallback ke berita
function goBack(){
    if (window.history.length > 1) {
        window.history.back()
    } else {
        try { router.visit(route('berita')) } catch { router.visit('/berita') }
    }
}

function backToCheckout(){
    if (!form.alamat) return alert('Isi alamat terlebih dahulu.')
    const pid = checkoutIntent.id_produk
    const qty = checkoutIntent.qty || 1
    router.visit(`/checkout/${pid}?qty=${qty}`)
}
</script>

<template>
    <div class="flex flex-col min-h-screen bg-slate-50">
        <Header />

        <main class="flex-1 w-full max-w-3xl p-6 mx-auto mt-16">
        <h1 class="mb-6 text-2xl font-semibold text-center">Profil Saya</h1>

        <div v-if="needAddress && checkoutIntent" class="px-4 py-3 mb-4 text-sm text-red-700 border border-red-300 rounded bg-red-50">
            *Isikan alamat anda sebelum melakukan Checkout Produk
        </div>

        <div v-if="$page.props.flash?.success" class="px-4 py-2 mb-4 text-green-800 bg-green-100 rounded">
            {{ $page.props.flash.success }}
        </div>

        <div class="p-6 border border-green-200 shadow bg-green-50/70 rounded-xl">
            <form @submit.prevent="save" class="grid grid-cols-1 gap-4">
            <div>
                <label class="block mb-1 text-sm">Username</label>
                <input v-model="form.username" class="w-full px-3 py-2 border border-green-200 rounded-md bg-white/80" />
                <p v-if="form.errors.username" class="mt-1 text-sm text-red-600">{{ form.errors.username }}</p>
            </div>
            <div>
                <label class="block mb-1 text-sm">Nama</label>
                <input v-model="form.nama" class="w-full px-3 py-2 border border-green-200 rounded-md bg-white/80" placeholder="Opsional" />
                <p v-if="form.errors.nama" class="mt-1 text-sm text-red-600">{{ form.errors.nama }}</p>
            </div>
            <div>
                <label class="block mb-1 text-sm">Email</label>
                <input v-model="form.email" type="email" class="w-full px-3 py-2 border border-green-200 rounded-md bg-white/80" />
                <p v-if="form.errors.email" class="mt-1 text-sm text-red-600">{{ form.errors.email }}</p>
            </div>
            <div>
                <label class="block mb-1 text-sm">Nomor Telepon</label>
                <input v-model="form.no_telp" inputmode="numeric" pattern="[0-9]*" maxlength="20"
                    @input="onPhoneInput"
                    class="w-full px-3 py-2 border border-green-200 rounded-md bg-white/80" />
                <p v-if="form.errors.no_telp" class="mt-1 text-sm text-red-600">{{ form.errors.no_telp }}</p>
            </div>
            <div>
                <label class="block mb-1 text-sm">Alamat</label>
                <input v-model="form.alamat" class="w-full px-3 py-2 border border-green-200 rounded-md bg-white/80" />
                <p v-if="form.errors.alamat" class="mt-1 text-sm text-red-600">{{ form.errors.alamat }}</p>
            </div>

            <div class="flex flex-wrap gap-3 mt-2">
                <button type="submit" :disabled="form.processing"
                        class="px-5 py-2 text-white bg-green-600 rounded-lg hover:bg-green-700">
                {{ form.processing ? 'Menyimpan...' : 'Simpan' }}
                </button>

                <button @click="goBack"
                class="px-4 py-2 text-sm text-white bg-red-600 rounded-lg hover:bg-red-700">
                    Kembali
                </button>

                <button
                v-if="checkoutIntent"
                type="button"
                @click="backToCheckout"
                class="px-5 py-2 text-green-700 bg-green-100 rounded-lg hover:bg-green-200"
                :disabled="!form.alamat">
                Kembali ke Checkout
                </button>
            </div>
            </form>
        </div>
        </main>

        <Footer />
    </div>
</template>
