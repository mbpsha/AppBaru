import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  // Data Berita (Contoh)
  static const List<Map<String, dynamic>> _newsData = [
    {
      'id': 1,
      'title': 'Petani Sayuran Mulai Terapkan Irigasi Otomatis untuk Hemat Air',
      'excerpt': 'Penulis: Tim Ngundur – Selamat Berjuang Sukses',
      'status': 'Published',
      'date': '4/12/2025',
    },
    // Tambahkan data berita lainnya di sini jika ada
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
                    'News ',
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
                        // Implementasi navigasi ke halaman tambah berita
                        print('Add News clicked!');
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text(
                        'Add News',
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

              // --- Kartu Tabel Berita ---
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
                      // Tidak ada judul 'All Products' di sini, langsung tabel

                      // Memastikan tabel memanjang penuh selebar halaman
                      LayoutBuilder(
                        builder: (context, boxConstraints) {
                          // Lebar minimum untuk scroll horizontal di mobile
                          final minTableWidth = isMobile
                              ? 800.0
                              : boxConstraints.maxWidth;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: minTableWidth,
                              child: _buildDataTable(context, isMobile),
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

  Widget _buildDataTable(BuildContext context, bool isMobile) {
    const columns = <DataColumn>[
      DataColumn(label: Text('TITLE')),
      DataColumn(label: Text('EXCERPT')),
      DataColumn(label: Text('STATUS')),
      DataColumn(label: Text('DATE')),
      DataColumn(label: Text('ACTIONS')),
    ];

    final rows = _newsData.map((data) {
      return DataRow(
        cells: <DataCell>[
          // Kolom TITLE
          DataCell(
            SizedBox(
              width: isMobile
                  ? 200
                  : 300, // Memberi lebar minimum agar tidak terlalu sempit
              child: Text(
                data['title']!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Kolom EXCERPT
          DataCell(
            SizedBox(
              width: isMobile ? 180 : 300,
              child: Text(
                data['excerpt']!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Kolom STATUS (Menggunakan Container/Chip untuk tampilan 'Published')
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                data['status']!,
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          // Kolom DATE
          DataCell(Text(data['date']!)),
          // Kolom ACTIONS
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue[600], size: 20),
                  onPressed: () => print('Edit ${data['title']}'),
                  tooltip: 'Edit News',
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[600], size: 20),
                  onPressed: () => print('Delete ${data['title']}'),
                  tooltip: 'Delete News',
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return DataTable(
      // Menggunakan padding/margin kecil agar tata letak rapi
      columnSpacing: isMobile ? 12 : 30,
      horizontalMargin: isMobile ? 8 : 10,
      columns: columns,
      rows: rows,
    );
  }
}
