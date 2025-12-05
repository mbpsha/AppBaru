<script setup>
import Header from '@/Components/User/Header.vue'
import Footer from '@/Components/User/Footer.vue'
import { Head, useForm, router } from '@inertiajs/vue3'

const props = defineProps({
  id_produk: { type: Number, required: true },
  qty: { type: Number, default: 1 },
  prefill: { type: Object, default: () => ({}) }
})

const form = useForm({
  nama: props.prefill.nama || '',
  phone: props.prefill.phone || '',
  prov_kab: props.prefill.prov_kab || '',
  street: props.prefill.street || '',
  detail: props.prefill.detail || '',
  qty: props.qty
})

function submit() {
  form.post(route('checkout.address.save', { id_produk: props.id_produk }), {
    preserveScroll: true
  })
}

function backToCheckout() {
  router.visit(route('checkout.show', { id_produk: props.id_produk }) + `?qty=${props.qty}`)
}
</script>

<template>
  <div class="min-h-screen text-gray-900 bg-gray-50">
    <Header />
    <Head title="Alamat Baru" />
    <main class="max-w-3xl px-4 pt-24 pb-16 mx-auto">
      <h1 class="mb-6 text-2xl font-semibold">Alamat Baru</h1>

      <div class="p-5 bg-gray-100 border shadow-sm rounded-xl">
        <form @submit.prevent="submit" class="space-y-4">
          <div>
            <label class="block mb-1 text-sm">Nama lengkap</label>
            <input v-model="form.nama" class="w-full px-3 py-2 bg-white border rounded-md" />
            <p v-if="form.errors.nama" class="mt-1 text-xs text-red-600">{{ form.errors.nama }}</p>
          </div>

          <div>
            <label class="block mb-1 text-sm">Nomor Telepon</label>
            <input v-model="form.phone" class="w-full px-3 py-2 bg-white border rounded-md" />
            <p v-if="form.errors.phone" class="mt-1 text-xs text-red-600">{{ form.errors.phone }}</p>
          </div>

          <div>
            <label class="block mb-1 text-sm">Provinsi, Kota, Kecamatan, Kelurahan, Kode pos</label>
            <input v-model="form.prov_kab" class="w-full px-3 py-2 bg-white border rounded-md" />
            <p v-if="form.errors.prov_kab" class="mt-1 text-xs text-red-600">{{ form.errors.prov_kab }}</p>
          </div>

          <div>
            <label class="block mb-1 text-sm">Nama jalan, Gedung, No. Rumah</label>
            <input v-model="form.street" class="w-full px-3 py-2 bg-white border rounded-md" />
            <p v-if="form.errors.street" class="mt-1 text-xs text-red-600">{{ form.errors.street }}</p>
          </div>

          <div>
            <label class="block mb-1 text-sm">Detail lainnya (Cth : Blok / Unit No, patokan)</label>
            <input v-model="form.detail" class="w-full px-3 py-2 bg-white border rounded-md" />
            <p v-if="form.errors.detail" class="mt-1 text-xs text-red-600">{{ form.errors.detail }}</p>
          </div>

          <div class="flex items-center gap-3 pt-2">
            <button type="submit" :disabled="form.processing"
                    class="px-6 py-2 text-white bg-green-500 rounded-lg hover:bg-green-600">
              {{ form.processing ? 'Menyimpan...' : 'Simpan' }}
            </button>
            <button type="button" @click="backToCheckout"
                    class="px-6 py-2 text-gray-700 bg-gray-200 rounded-lg hover:bg-gray-300">
              Kembali ke Checkout
            </button>
          </div>
        </form>
      </div>
    </main>
    <Footer />
  </div>
</template>
