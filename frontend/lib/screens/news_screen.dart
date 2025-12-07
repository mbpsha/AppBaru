// lib/screens/news_screen.dart

import 'package:flutter/material.dart';

// =======================================================================
// 1. NewsScreen (Halaman Utama Manajemen Berita)
// =======================================================================

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
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

  // --- Fungsi untuk Menampilkan Modal Add News ---
  void _showAddNewsModal(BuildContext context, bool isMobile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Tentukan lebar dialog
        final dialogWidth = isMobile
            ? MediaQuery.of(context).size.width * 0.9
            : 600.0;

        return AlertDialog(
          // Judul Dialog
          title: const Text('Add News'),
          content: SizedBox(
            width: dialogWidth,
            // Memanggil widget formulir yang didefinisikan di bawah
            child: const AddNewsForm(),
          ),
          actionsAlignment: MainAxisAlignment.end,
          buttonPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implementasi logika simpan berita baru
                Navigator.of(context).pop();
                print('Saving new news...');
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

  // --- Widget Utama NewsScreen ---
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
                        // PANGGIL FUNGSI MODAL DI SINI
                        _showAddNewsModal(context, isMobile);
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
                      const Divider(),
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

  // --- Widget Data Table Berita ---
  Widget _buildDataTable(BuildContext context, bool isMobile) {
    const columns = <DataColumn>[
      DataColumn(label: Text('TITLE')),
      DataColumn(label: Text('EXCERPT')),
      DataColumn(label: Text('STATUS')),
      DataColumn(label: Text('DATE')),
      DataColumn(label: Text('ACTIONS')),
    ];

    final rows = _newsData.map((data) {
      final statusColor = data['status'] == 'Published'
          ? Colors.green
          : Colors.amber;
      return DataRow(
        cells: <DataCell>[
          // Kolom TITLE
          DataCell(
            SizedBox(
              width: isMobile ? 200 : 300,
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
          // Kolom STATUS
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                data['status']!,
                style: TextStyle(
                  color: statusColor.shade700,
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
                // Tombol Edit
                ElevatedButton(
                  onPressed: () => print('Edit ${data['title']}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                // Tombol Delete
                ElevatedButton(
                  onPressed: () => print('Delete ${data['title']}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Delete'),
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
// 2. AddNewsForm (Widget Formulir Modal)
//    Menggunakan Stateful agar checkbox dapat diubah
// =======================================================================

class AddNewsForm extends StatefulWidget {
  const AddNewsForm({Key? key}) : super(key: key);

  @override
  State<AddNewsForm> createState() => _AddNewsFormState();
}

class _AddNewsFormState extends State<AddNewsForm> {
  // State untuk checkbox Publish
  bool _publishImmediately = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text('Title', style: TextStyle(fontWeight: FontWeight.w500)),
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

          // Excerpt (Ringkasan)
          const Text(
            'Excerpt (Ringkasan)',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const TextField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Ringkasan singkat berita (max 500 karakter)',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 16),

          // Content (Isi Berita)
          const Text(
            'Content (Isi Berita)',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const TextField(
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Tulis isi berita lengkap di sini...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 16),

          // Image Input
          const Text('Image', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
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
                const Text('No file chosen'),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Upload gambar berita',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Publish Checkbox
          Row(
            children: [
              Checkbox(
                value: _publishImmediately,
                onChanged: (bool? newValue) {
                  setState(() {
                    _publishImmediately = newValue!;
                  });
                },
                activeColor: Colors.green,
              ),
              const Text('Publish immediately'),
            ],
          ),
        ],
      ),
    );
  }
}
