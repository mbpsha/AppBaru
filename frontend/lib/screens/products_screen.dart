// lib/screens/products_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/product_service.dart';
import '../services/admin_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService _productService = ProductService();
  final AdminService _adminService = AdminService();
  List<dynamic> _productData = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _productService.getProducts();
      if (result['success'] && mounted) {
        setState(() {
          _productData = result['products'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load products';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading products: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteProduct(int productId, String productName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "$productName"?'),
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
        final result = await _adminService.deleteProduct(productId);
        if (result['success'] && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadProducts(); // Reload data
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Failed to delete product'),
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

  // --- Fungsi untuk Menampilkan Modal ---
  void _showAddProductModal(BuildContext context, bool isMobile) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Tentukan lebar berdasarkan mode desktop/mobile
        final dialogWidth = isMobile
            ? MediaQuery.of(dialogContext).size.width * 0.9
            : 600.0;

        return AlertDialog(
          // Judul Dialog
          title: const Text('Add New Product'),
          // Batasi lebar dialog
          content: SizedBox(
            width: dialogWidth,
            child: AddProductForm(
              onSave: () {
                Navigator.of(dialogContext).pop(true); // Return true on success
              },
            ),
          ),
        );
      },
    );

    // Reload products if saved successfully
    if (result == true) {
      _loadProducts();
    }
  }

  void _showEditProductModal(
    BuildContext context,
    bool isMobile,
    Map<String, dynamic> productData,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final dialogWidth = isMobile
            ? MediaQuery.of(dialogContext).size.width * 0.9
            : 600.0;

        return AlertDialog(
          title: const Text('Edit Product'),
          content: SizedBox(
            width: dialogWidth,
            child: AddProductForm(
              productData: productData,
              onSave: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ),
        );
      },
    );

    if (result == true) {
      _loadProducts();
    }
  }

  // --- Widget Utama ProductsScreen ---
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
                  onPressed: _loadProducts,
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
      final productId = data['id_produk'] ?? data['id'];
      final productName = data['nama_produk'] ?? data['name'] ?? 'Unknown';
      final price = data['harga'] ?? data['price'] ?? 0;
      final stock = data['stok'] ?? data['stock'] ?? 0;
      // Prioritize gambar_url (full URL) over gambar (path)
      final imageUrl = data['gambar_url'] ?? data['gambar'] ?? data['image'];

      return DataRow(
        cells: <DataCell>[
          DataCell(Text(productId.toString())),
          DataCell(
            // Menampilkan gambar produk dari URL atau placeholder
            SizedBox(
              width: 40,
              height: 40,
              child: imageUrl != null
                  ? _buildProductImage(imageUrl)
                  : const Icon(Icons.image, size: 28, color: Colors.grey),
            ),
          ),
          DataCell(Text(productName)),
          DataCell(Text('Rp ${price.toString()}')),
          DataCell(Text('$stock unit')),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green[600], size: 20),
                  onPressed: () =>
                      _showEditProductModal(context, isMobile, data),
                  tooltip: 'Edit Product',
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[600], size: 20),
                  onPressed: () => _deleteProduct(productId, productName),
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

  Widget _buildProductImage(String imageUrl) {
    print('🖼️ Image URL from API: $imageUrl'); // DEBUG
    
    // Cek apakah imageUrl sudah berupa data URL (base64)
    if (imageUrl.startsWith('data:image')) {
      print('📦 Using base64 image'); // DEBUG
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('❌ Base64 image error: $error'); // DEBUG
            return const Icon(Icons.image, size: 28, color: Colors.grey);
          },
        );
      } catch (e) {
        print('❌ Base64 decode error: $e'); // DEBUG
        return const Icon(Icons.broken_image, size: 28, color: Colors.red);
      }
    }

    // Jika bukan base64, asumsi URL dari server
    // Jika URL sudah lengkap (dimulai dengan http), gunakan langsung
    if (imageUrl.startsWith('http')) {
      print('🌐 Using full HTTP URL: $imageUrl'); // DEBUG
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Network image error: $error'); // DEBUG
          return const Icon(Icons.image, size: 28, color: Colors.grey);
        },
      );
    }

    // Jika hanya nama file atau path, tambahkan base URL
    const baseUrl = 'http://localhost:8000';
    String fullUrl;

    if (imageUrl.startsWith('/storage/')) {
      // Path already includes /storage/
      fullUrl = '$baseUrl$imageUrl';
      print('🔗 Path type: /storage/ -> $fullUrl'); // DEBUG
    } else if (imageUrl.startsWith('storage/')) {
      // Path starts with storage/ (without leading slash)
      fullUrl = '$baseUrl/$imageUrl';
      print('🔗 Path type: storage/ -> $fullUrl'); // DEBUG
    } else if (imageUrl.startsWith('products/')) {
      // Path is like products/filename.jpg
      fullUrl = '$baseUrl/storage/$imageUrl';
      print('🔗 Path type: products/ -> $fullUrl'); // DEBUG
    } else if (imageUrl.startsWith('/')) {
      // Path starts with / but not /storage/
      fullUrl = '$baseUrl$imageUrl';
      print('🔗 Path type: / -> $fullUrl'); // DEBUG
    } else {
      // Just a filename or other relative path
      fullUrl = '$baseUrl/storage/products/$imageUrl';
      print('🔗 Path type: filename -> $fullUrl'); // DEBUG
    }

    return Image.network(
      fullUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('❌ Network image error for $fullUrl: $error'); // DEBUG
        return const Icon(Icons.image, size: 28, color: Colors.grey);
      },
    );
  }
}

// =======================================================================
// 2. Widget Formulir "Add New Product" (Sesuai Tampilan yang Diunggah)
// =======================================================================

class AddProductForm extends StatefulWidget {
  final VoidCallback onSave;
  final Map<String, dynamic>? productData;

  const AddProductForm({Key? key, required this.onSave, this.productData})
    : super(key: key);

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String? _selectedFileName;
  PlatformFile? _selectedFile;
  bool _isSaving = false;
  int? _editingProductId;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.productData != null) {
      _editingProductId =
          widget.productData!['id_produk'] ?? widget.productData!['id'];
      _nameController.text = widget.productData!['nama_produk'] ?? '';
      _descriptionController.text = widget.productData!['deskripsi'] ?? '';
      _priceController.text = (widget.productData!['harga'] ?? 0).toString();
      _stockController.text = (widget.productData!['stok'] ?? 0).toString();
      _existingImageUrl = widget.productData!['gambar'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  String? _convertImageToBase64() {
    if (_selectedFile?.bytes != null) {
      try {
        final bytes = _selectedFile!.bytes!;
        final base64String = base64Encode(bytes);

        // Detect image type from file extension
        String mimeType = 'image/png';
        final extension = _selectedFile!.extension?.toLowerCase();
        if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == 'png') {
          mimeType = 'image/png';
        } else if (extension == 'gif') {
          mimeType = 'image/gif';
        } else if (extension == 'webp') {
          mimeType = 'image/webp';
        }

        return 'data:$mimeType;base64,$base64String';
      } catch (e) {
        print('Error converting image to base64: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final adminService = AdminService();
      final imageData = _convertImageToBase64() ?? _existingImageUrl;

      final result = _editingProductId == null
          ? await adminService.createProduct(
              namaProduk: _nameController.text.trim(),
              deskripsi: _descriptionController.text.trim(),
              harga: int.parse(_priceController.text.trim()),
              stok: int.parse(_stockController.text.trim()),
              gambar: imageData,
            )
          : await adminService.updateProduct(
              productId: _editingProductId!,
              namaProduk: _nameController.text.trim(),
              deskripsi: _descriptionController.text.trim(),
              harga: int.parse(_priceController.text.trim()),
              stok: int.parse(_stockController.text.trim()),
              gambar: imageData,
            );

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _editingProductId == null
                    ? 'Product created successfully'
                    : 'Product updated successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          widget.onSave(); // Trigger parent callback to close modal and reload
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to create product'),
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

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web - loads file bytes
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Validate file size (max 10MB)
        const maxSizeInBytes = 10 * 1024 * 1024; // 10 MB
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
      print('Error picking file: $e');
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
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
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Product name is required';
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

            // Description
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
              decoration: const InputDecoration(
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
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Price is required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          if (int.parse(value) <= 0) {
                            return 'Must be > 0';
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
                      TextFormField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Stock is required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          if (int.parse(value) < 0) {
                            return 'Must be >= 0';
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
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Choose File'),
                  ),
                  const SizedBox(width: 10),
                  // Nama File yang dipilih atau placeholder
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
              'Upload product image',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            // Preview gambar jika ada
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
                      ? Image.memory(
                          _selectedFile!.bytes!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Preview not available',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'Image selected',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'File size: ${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 24),
            // Action buttons
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
                  onPressed: _isSaving ? null : _saveProduct,
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
