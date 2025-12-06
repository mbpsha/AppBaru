import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
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
        // Token invalid or expired
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
    return SafeArea(
      child: Padding(
        // buat kiri nol supaya logo benar-benar di pojok kiri (SafeArea masih melindungi)
        padding: EdgeInsets.only(left: 0, right: 22, top: 12, bottom: 12),
        child: Row(
          children: [
            // LOGO di pojok kiri atas (pakai file assets/images/logo-ngundur.png)
            Container(
              margin: EdgeInsets.only(left: 4, right: 12),
              child: Image.asset(
                'assets/images/logo-ngundur.png',
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // log ke console supaya keliatan kenapa gagal (case-sensitive path di web)
                  debugPrint(
                    'ERROR loading asset: assets/images/logo-ngundur.png',
                  );
                  debugPrint(error.toString());
                  if (stackTrace != null) debugPrint(stackTrace.toString());
                  // tampilkan info lebih jelas di UI
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

            // nav tengah: gunakan Expanded + Center agar nav berada di tengah header
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

            // tombol di kanan - conditional based on login state
            ...(_isLoggedIn
                ? [
                    // Show user menu when logged in
                    PopupMenuButton(
                      icon: CircleAvatar(
                        backgroundColor: Colors.green[700],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      tooltip: _userName,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.shopping_bag, size: 20),
                              SizedBox(width: 8),
                              Text('My Orders'),
                            ],
                          ),
                          onTap: () {
                            // Navigate to orders
                          },
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.person, size: 20),
                              SizedBox(width: 8),
                              Text('Profile'),
                            ],
                          ),
                          onTap: () {
                            // Navigate to profile
                          },
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          onTap: _handleLogout,
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.green[700]),
                      onPressed: () {
                        // Navigate to cart
                      },
                    ),
                  ]
                : [
                    // Show login/register buttons when not logged in
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green[700],
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        shape: MaterialStateProperty.all(StadiumBorder()),
                      ),
                      child: Text('Masuk'),
                    ),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.green[300]!),
                        ),
                        shape: MaterialStateProperty.all(StadiumBorder()),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.green[700],
                        ),
                      ),
                      child: Text('Daftar'),
                    ),
                  ]),
          ],
        ),
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
// ...existing code...