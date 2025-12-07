import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  // Tambahkan implements PreferredSizeWidget untuk memudahkan penggunaan di AppBar di main.dart
  @override
  _HeaderState createState() => _HeaderState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10); // Tinggi Header
}

class _HeaderState extends State<Header> {
  bool _isLoggedIn = false;
  String _userName = '';
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await ApiClient().getToken();
    if (token != null) {
      try {
        final result = await _authService.getCurrentUser();
        if (result['success'] && mounted) {
          setState(() {
            _isLoggedIn = true;
            _userName =
                result['user']['nama'] ?? result['user']['name'] ?? 'User';
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoggedIn = false);
        }
      }
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _authService.logout();
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _userName = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed'), backgroundColor: Colors.red),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Tentukan lebar layar untuk responsif
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      // Padding diatur ulang agar konsisten
      padding: EdgeInsets.only(left: 0, right: 22, top: 12, bottom: 12),
      child: Row(
        children: [
          // 1. LOGO
          Container(
            margin: EdgeInsets.only(left: isMobile ? 12 : 4, right: 12),
            child: Image.asset(
              'assets/images/logo-ngundur.png',
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // ... (errorBuilder tetap sama) ...
                debugPrint('ERROR loading asset: assets/images/logo-ngundur.png');
                return Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      'logo missing\nassets/images/logo-ngundur.png',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Navigasi Tengah (Hanya muncul di layar BESAR)
          if (!isMobile)
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NavText('Home', isActive: true),
                    SizedBox(width: 16),
                    _NavText('Toko'),
                    SizedBox(width: 16),
                    _NavText('Berita'),
                    SizedBox(width: 16),
                    _NavText('Tentang'),
                    SizedBox(width: 16),
                    _NavText('Blog'),
                  ],
                ),
              ),
            ),
          
          // 3. Spasi untuk mendorong tombol ke kanan di mobile
          if (isMobile)
            Spacer(),

          // 4. Tombol/Menu Kanan
          ...(_isLoggedIn
              ? [
                  // Menu Akun (Hanya ditampilkan sebagai Popup di Desktop agar hemat ruang)
                  if (!isMobile)
                    PopupMenuButton<String>(
                      icon: CircleAvatar(
                        backgroundColor: Colors.green[700],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      tooltip: _userName,
                      onSelected: (value) {
                        if (value == 'logout') _handleLogout();
                        // Tambahkan navigasi lain di sini
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Divider(),
                            ],
                          ),
                        ),
                        PopupMenuItem(value: 'orders', child: Row(children: [Icon(Icons.shopping_bag, size: 20), SizedBox(width: 8), Text('My Orders')])),
                        PopupMenuItem(value: 'profile', child: Row(children: [Icon(Icons.person, size: 20), SizedBox(width: 8), Text('Profile')])),
                        PopupMenuItem(
                            value: 'logout', 
                            child: Row(children: [Icon(Icons.logout, size: 20, color: Colors.red), SizedBox(width: 8), Text('Logout', style: TextStyle(color: Colors.red))])),
                      ],
                    ),
                  
                  // Ikon Keranjang
                  SizedBox(width: isMobile ? 0 : 8),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.green[700]),
                    onPressed: () {
                      // Navigate to cart
                    },
                  ),
                ]
              : [
                  // Tombol Masuk/Daftar (Hanya di layar BESAR)
                  if (!isMobile)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green[700]),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(StadiumBorder()),
                      ),
                      child: Text('Masuk'),
                    ),
                  if (!isMobile) SizedBox(width: 10),
                  if (!isMobile)
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(color: Colors.green[300]!)),
                        shape: MaterialStateProperty.all(StadiumBorder()),
                        foregroundColor: MaterialStateProperty.all(Colors.green[700]),
                      ),
                      child: Text('Daftar'),
                    ),
                ]),
          
          // 5. Menu Hamburger (Hanya muncul di layar MOBILE)
          if (isMobile)
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                // Trigger Drawer yang sudah didefinisikan di main.dart
                Scaffold.of(context).openEndDrawer(); 
              },
            ),
        ],
      ),
    );
  }
}

class _NavText extends StatelessWidget {
  final String text;
  final bool isActive;
  _NavText(this.text, {this.isActive = false});
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isActive ? Colors.black : Colors.grey[700],
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}