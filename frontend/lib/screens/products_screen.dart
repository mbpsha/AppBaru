// lib/screens/products_screen.dart

import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const List<Map<String, dynamic>> _productData = [
    {
      'id': 1,
      'image_asset':
          'assets/images/solar_panel.png', // Ganti dengan path gambar yang benar
      'name': 'IoT sampel',
      'price': 'Rp 100000.00',
      'stock': '9 unit',
    },
    // Tambahkan data produk lainnya di sini jika ada
  ];

  // --- Fungsi untuk Menampilkan Modal ---
  void _showAddProductModal(BuildContext context, bool isMobile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Tentukan lebar berdasarkan mode desktop/mobile
        final dialogWidth = isMobile
            ? MediaQuery.of(context).size.width * 0.9
            : 600.0;

        return AlertDialog(
          // Judul Dialog
          title: const Text('Add New Product'),
          // Batasi lebar dialog
          content: SizedBox(
            width: dialogWidth,
            child:
                const AddProductForm(), // Widget Form yang sudah dibuat di bawah
          ),
          // Aksi tombol pada dialog (Cancel/Save)
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Tutup dialog
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implementasi logika simpan produk baru
                Navigator.of(context).pop(); // Tutup dialog setelah simpan
                print('Saving new product...');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // --- Widget Utama ProductsScreen ---
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Halaman & Tombol Add New Product ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Products ', // Judul halaman
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(
                    height: isMobile ? 40 : 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // PANGGIL FUNGSI MODAL DI SINI
                        _showAddProductModal(context, isMobile);
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text(
                        'Add New Product',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'All Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              // --- Kartu Tabel Produk ---
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 8 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),

                      // Menggunakan LayoutBuilder untuk mendapatkan lebar yang tersedia
                      LayoutBuilder(
                        builder: (context, boxConstraints) {
                          final minTableWidth = isMobile
                              ? 700.0
                              : boxConstraints.maxWidth;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: minTableWidth,
                              child: _buildDataTable(
                                context,
                                isMobile,
                                minTableWidth,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataTable(
    BuildContext context,
    bool isMobile,
    double minTableWidth,
  ) {
    const columns = <DataColumn>[
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('IMAGE')),
      DataColumn(label: Text('NAME')),
      DataColumn(label: Text('PRICE'), numeric: true),
      DataColumn(label: Text('STOCK'), numeric: true),
      DataColumn(label: Text('ACTIONS')),
    ];

    final rows = _productData.map((data) {
      return DataRow(
        cells: <DataCell>[
          DataCell(Text(data['id'].toString())),
          DataCell(
            // Menampilkan gambar produk
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                data['image_asset']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 28,
                  color: Colors.black54,
                ), // Placeholder jika gambar gagal dimuat
              ),
            ),
          ),
          DataCell(Text(data['name']!)),
          DataCell(Text(data['price']!)),
          DataCell(Text(data['stock']!)),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green[600], size: 20),
                  onPressed: () => print('Edit ${data['name']}'),
                  tooltip: 'Edit Product',
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[600], size: 20),
                  onPressed: () => print('Delete ${data['name']}'),
                  tooltip: 'Delete Product',
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return DataTable(
      columnSpacing: isMobile ? 12 : 30,
      horizontalMargin: isMobile ? 8 : 10,
      columns: columns,
      rows: rows,
    );
  }
}

// =======================================================================
// 2. Widget Formulir "Add New Product" (Sesuai Tampilan yang Diunggah)
// =======================================================================

class AddProductForm extends StatelessWidget {
  const AddProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          const Text(
            'Product Name',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 16),

          // Price and Stock (Side by Side)
          Row(
            children: [
              // Price (Rp)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price (Rp)',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Stock
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stock',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Product Image
          const Text(
            'Product Image',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                // Tombol Choose File
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implementasi memilih file gambar
                    print('Choose File clicked');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Choose File'),
                ),
                const SizedBox(width: 10),
                // Nama File Placeholder
                const Text('No file chosen'),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Upload product image',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
