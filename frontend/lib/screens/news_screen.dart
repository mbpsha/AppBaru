// lib/screens/news_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/news_service.dart';
import '../services/admin_service.dart';

// =======================================================================
// 1. NewsScreen (Halaman Utama Manajemen Berita)
// =======================================================================

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  List<dynamic> _newsData = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _newsService.getAllNews();
      if (result['success'] && mounted) {
        setState(() {
          _newsData = result['news'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load news';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading news: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteNews(int newsId, String newsTitle) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "$newsTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final result = await AdminService().deleteNews(newsId);
        if (result['success'] && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('News deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadNews();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Failed to delete news'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _showAddNewsModal(BuildContext context, bool isMobile) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final dialogWidth = isMobile
            ? MediaQuery.of(dialogContext).size.width * 0.9
            : 600.0;

        return AlertDialog(
          title: const Text('Add News'),
          content: SizedBox(
            width: dialogWidth,
            child: AddNewsForm(
              onSave: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ),
        );
      },
    );

    if (result == true) {
      _loadNews();
    }
  }

  // --- Widget Utama NewsScreen ---
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        // Show loading indicator
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message
        if (_errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadNews,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

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
      final newsId = data['id_berita'] ?? data['id'];
      final title = data['judul'] ?? data['title'] ?? 'No Title';
      final excerpt = data['excerpt'] ?? data['penulis'] ?? 'No excerpt';
      final status = data['status'] ?? 'Draft';
      final createdAt = data['created_at'] ?? data['date'] ?? '-';

      // Format date if it's a full timestamp
      String displayDate = createdAt;
      if (createdAt.contains('T') || createdAt.contains(' ')) {
        try {
          final dateTime = DateTime.parse(createdAt);
          displayDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
        } catch (e) {
          displayDate = createdAt.split('T').first;
        }
      }

      final statusColor = status.toLowerCase() == 'published'
          ? Colors.green
          : Colors.amber;
      return DataRow(
        cells: <DataCell>[
          // Kolom TITLE
          DataCell(
            SizedBox(
              width: isMobile ? 200 : 300,
              child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ),
          // Kolom EXCERPT
          DataCell(
            SizedBox(
              width: isMobile ? 180 : 300,
              child: Text(
                excerpt,
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
                status,
                style: TextStyle(
                  color: statusColor.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          // Kolom DATE
          DataCell(Text(displayDate)),
          // Kolom ACTIONS
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tombol Delete
                ElevatedButton(
                  onPressed: () => _deleteNews(newsId, title),
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
  final VoidCallback onSave;

  const AddNewsForm({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddNewsForm> createState() => _AddNewsFormState();
}

class _AddNewsFormState extends State<AddNewsForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  bool _publishImmediately = true;
  PlatformFile? _selectedFile;
  String? _selectedFileName;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        const maxSizeInBytes = 10 * 1024 * 1024;
        if (file.size > maxSizeInBytes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File size must be less than 10 MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        setState(() {
          _selectedFileName = file.name;
          _selectedFile = file;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _convertImageToBase64() {
    if (_selectedFile?.bytes != null) {
      try {
        final bytes = _selectedFile!.bytes!;
        final base64String = base64Encode(bytes);
        String mimeType = 'image/png';
        final extension = _selectedFile!.extension?.toLowerCase();
        if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == 'png') {
          mimeType = 'image/png';
        }
        return 'data:$mimeType;base64,$base64String';
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final adminService = AdminService();
      final result = await adminService.createNews(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        excerpt: _excerptController.text.trim(),
        image: _convertImageToBase64(),
        isPublished: _publishImmediately,
      );

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('News created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onSave();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to save news'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text('Title', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
              decoration: const InputDecoration(
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
            TextFormField(
              controller: _excerptController,
              maxLines: 2,
              decoration: const InputDecoration(
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
            TextFormField(
              controller: _contentController,
              maxLines: 8,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Content is required';
                }
                return null;
              },
              decoration: const InputDecoration(
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
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Choose File'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedFileName ?? 'No file chosen',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Upload gambar berita',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 10),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _selectedFile!.bytes != null
                      ? Image.memory(_selectedFile!.bytes!, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.image, size: 50)),
                ),
              ),
            ],
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
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
