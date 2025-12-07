// lib/screens/products_screen.dart
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

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
                    'Products ',
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
                        // Implementasi navigasi ke halaman tambah produk
                        print('Add New Product clicked!');
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

              // --- Kartu Tabel Produk ---
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                // Menggunakan FractionallySizedBox untuk memastikan Card mengambil lebar penuh
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 8 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          'All Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(),

                      // Menggunakan LayoutBuilder untuk mendapatkan lebar yang tersedia
                      LayoutBuilder(
                        builder: (context, boxConstraints) {
                          // Memastikan lebar minimum tabel adalah lebar yang tersedia saat desktop (agar full width)
                          // atau lebar tetap yang cukup besar saat mobile (agar bisa di-scroll)
                          final minTableWidth = isMobile
                              ? 700.0
                              : boxConstraints.maxWidth;

                          return SingleChildScrollView(
                            scrollDirection:
                                Axis.horizontal, // Selalu horizontal scroll
                            child: SizedBox(
                              width: minTableWidth, // Memaksa lebar minimum
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

  // Mengubah parameter untuk menerima lebar minimum tabel
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
      // Kini DataTable di bungkus dengan SizedBox dengan lebar yang ditentukan
      columnSpacing: isMobile ? 12 : 30,
      horizontalMargin: isMobile ? 8 : 10,
      columns: columns,
      rows: rows,
    );
  }
}
