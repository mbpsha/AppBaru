import 'package:flutter/material.dart';
import '../widgets/header_clean.dart';
import '../widgets/sidebar_clean.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  Widget _buildStatCard(String title, String value, {Color? accent}) {
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
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        final gridCount = isMobile ? 1 : (constraints.maxWidth < 1200 ? 2 : 4);

        if (isMobile) {
          // Mobile / narrow layout: drawer + appbar
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
              child: SafeArea(child: AdminSidebarClean(width: 260)),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: gridCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatCard(
                        'Total Products',
                        '1',
                        accent: Colors.green[100],
                      ),
                      _buildStatCard(
                        'Total Users',
                        '2',
                        accent: Colors.green[100],
                      ),
                      _buildStatCard(
                        'Total Orders',
                        '0',
                        accent: Colors.purple[100],
                      ),
                      _buildStatCard(
                        'Pending Verification',
                        '0',
                        accent: Colors.yellow[100],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
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
                                onPressed: () {},
                                child: const Text('View All'),
                              ),
                            ],
                          ),
                          const Divider(),
                          const ListTile(
                            title: Text('IoT sampel'),
                            subtitle: Text('Rp 100000.00'),
                            trailing: Chip(label: Text('Terverifikasi')),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Users',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('View All'),
                              ),
                            ],
                          ),
                          const Divider(),
                          const ListTile(
                            title: Text('cicisapi'),
                            subtitle: Text('cicibarokah1@gmail.com'),
                            trailing: Chip(label: Text('user')),
                          ),
                          const ListTile(
                            title: Text('haha'),
                            subtitle: Text(
                              'arzetaputrikaila@student.uns.ac.id',
                            ),
                            trailing: Chip(label: Text('user')),
                          ),
                          const ListTile(
                            title: Text('zetaci'),
                            subtitle: Text('zetakaila@gmail.com'),
                            trailing: Chip(label: Text('admin')),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                          const SizedBox(height: 12),
                          Container(
                            height: 200,
                            color: Colors.grey[100],
                            child: const Center(
                              child: Text('Chart placeholder'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Desktop / wide layout: persistent sidebar
        return Scaffold(
          body: Row(
            children: [
              const AdminSidebarClean(),
              Expanded(
                child: Column(
                  children: [
                    const AdminHeaderClean(userName: 'zetaci'),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 18),
                            GridView.count(
                              crossAxisCount: gridCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildStatCard(
                                  'Total Products',
                                  '1',
                                  accent: Colors.green[100],
                                ),
                                _buildStatCard(
                                  'Total Users',
                                  '2',
                                  accent: Colors.green[100],
                                ),
                                _buildStatCard(
                                  'Total Orders',
                                  '0',
                                  accent: Colors.purple[100],
                                ),
                                _buildStatCard(
                                  'Pending Verification',
                                  '0',
                                  accent: Colors.yellow[100],
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Recent Products',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                child: const Text('View All'),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          const ListTile(
                                            title: Text('IoT sampel'),
                                            subtitle: Text('Rp 100000.00'),
                                            trailing: Chip(
                                              label: Text('Terverifikasi'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Recent Users',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                child: const Text('View All'),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          const ListTile(
                                            title: Text('cicisapi'),
                                            subtitle: Text(
                                              'cicibarokah1@gmail.com',
                                            ),
                                            trailing: Chip(label: Text('user')),
                                          ),
                                          const ListTile(
                                            title: Text('haha'),
                                            subtitle: Text(
                                              'arzetaputrikaila@student.uns.ac.id',
                                            ),
                                            trailing: Chip(label: Text('user')),
                                          ),
                                          const ListTile(
                                            title: Text('zetaci'),
                                            subtitle: Text(
                                              'zetakaila@gmail.com',
                                            ),
                                            trailing: Chip(
                                              label: Text('admin'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
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
                                      height: 220,
                                      color: Colors.grey[100],
                                      child: const Center(
                                        child: Text('Chart placeholder'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
