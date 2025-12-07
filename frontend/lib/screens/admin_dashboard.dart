import 'package:flutter/material.dart';
import '../widgets/header_clean.dart';
import '../widgets/sidebar_clean.dart';
// Impor halaman yang akan ditampilkan
import 'products_screen.dart';
import 'news_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // 1. STATE: Menyimpan index menu yang sedang aktif
  // Urutan index: 0=Dashboard, 1=Products, 2=News, 3=Logout
  int _selectedIndex = 0;

  // 2. DAFTAR KONTEN: Widget yang akan ditampilkan berdasarkan _selectedIndex
  final List<Widget> _contentWidgets = [
    const Placeholder(), // Placeholder untuk Dashboard, akan diganti di _buildBodyContent
    const ProductsScreen(), // Index 1
    const NewsScreen(), // Index 2
    const Center(child: Text('Logging Out...')), // Index 3
  ];

  // 3. HANDLER: Fungsi yang dipanggil saat item sidebar diklik
  void _onMenuItemSelected(int index) {
    if (index == 3) {
      // Index Logout
      print('Logout triggered! Index: $index');
      // TODO: Implementasi logic logout/navigasi ke login screen
      return;
    }

    setState(() {
      _selectedIndex = index; // Memperbarui index yang dipilih
    });

    // Tutup Drawer jika di mode Mobile setelah item dipilih
    if (MediaQuery.of(context).size.width < 800) {
      Navigator.of(context).pop();
    }
  }

  // 4. Widget untuk menampilkan konten yang dipilih, dengan logic khusus untuk Dashboard
  Widget _buildBodyContent() {
    if (_selectedIndex == 0) {
      // Jika Index 0 (Dashboard) yang dipilih, kita sertakan callback navigasi
      return DashboardContent(
        // Callback ini akan memanggil _onMenuItemSelected(1) untuk navigasi ke Products (Index 1)
        onViewAllProducts: () => _onMenuItemSelected(1),
      );
    }
    // Jika Index lain (Products, News, dll.)
    return _contentWidgets[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        // --- Mobile View (Drawer) ---
        if (isMobile) {
          return Scaffold(
            key: scaffoldKey,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(68),
              child: AdminHeaderClean(
                userName: 'zetaci',
                showMenu: true,
                onMenuPressed: () => scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            drawer: Drawer(
              child: SafeArea(
                child: AdminSidebarClean(
                  width: 260,
                  selectedIndex: _selectedIndex,
                  onItemSelected: _onMenuItemSelected,
                ),
              ),
            ),
            body: _buildBodyContent(),
          );
        }

        // --- Desktop View (Sidebar Persisten) ---
        return Scaffold(
          body: Row(
            children: [
              // Sidebar (Persisten) - Mengirimkan index yang dipilih
              AdminSidebarClean(
                selectedIndex: _selectedIndex,
                onItemSelected: _onMenuItemSelected,
              ),
              Expanded(
                child: Column(
                  children: [
                    // Header
                    const AdminHeaderClean(userName: 'zetaci'),
                    // Konten (Dashboard, Products, News, dll.)
                    Expanded(child: _buildBodyContent()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ------------------------------------------------------------------
// 5. CLASS DashboardContent yang sudah difilter dan ditambahkan callback
// ------------------------------------------------------------------

class DashboardContent extends StatelessWidget {
  // Menerima callback untuk navigasi "View All Products"
  final VoidCallback? onViewAllProducts;

  const DashboardContent({Key? key, this.onViewAllProducts}) : super(key: key);

  Widget _buildStatCard(String title, String value, {Color? accent}) {
    // Fungsi Card Statistik Anda (tidak diubah)
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent ?? Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        // Atur agar Stat Card hanya menampilkan satu item per baris (karena hanya satu item yang tersisa)
        final gridCount = 1;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 18),

              // Statistik Cards (Hanya 'Total Products' yang tersisa)
              GridView.count(
                crossAxisCount: gridCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                // Diatur agar Card tunggal terlihat lebih lebar/pendek
                childAspectRatio: isMobile ? 2.5 : 5.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                    'Total Products',
                    '1',
                    accent: Colors.green[100],
                  ),
                  // **Total Users, Total Orders, Pending Verification DIHAPUS**
                ],
              ),
              const SizedBox(height: 18),

              // Card Recent Products (Tampil di Mobile dan Desktop)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            // MENGGUNAKAN CALLBACK UNTUK NAVIGASI KE PRODUCTS
                            onPressed: onViewAllProducts,
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('IoT sampel'),
                        subtitle: const Text('Rp 100000.00'),
                        trailing: isMobile
                            ? SizedBox(
                                width: 85,
                                child: const Chip(
                                  label: Text(
                                    'Verifikasi',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              )
                            : const Chip(label: Text('Terverifikasi')),
                      ),
                    ],
                  ),
                ),
              ),

              // **Card Recent Users DIHAPUS** (Tidak ditampilkan di Desktop & Mobile)
              const SizedBox(height: 20),

              // Monthly Sales Overview
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Sales Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: isMobile ? 180 : 220,
                        color: Colors.grey[100],
                        child: const Center(child: Text('Chart placeholder')),
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
}
