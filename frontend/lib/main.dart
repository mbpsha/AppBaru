import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/homepage.dart';
import 'services/api_client.dart';
import 'services/auth_service.dart';
import 'screens/api_test_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize API Client
  await ApiClient().init();
  runApp(NgundurApp());
}

class NgundurApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngundur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', primaryColor: Colors.green[700]),
      home: HomePage(),
      routes: {
        '/api-test': (context) => ApiTestScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin/dashboard': (context) => AdminDashboard(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 1. Menggunakan PreferredSizeWidget untuk Header
      appBar: PreferredSize(
        preferredSize: Header().preferredSize,
        child: Header(),
      ),

      // 2. Tambahkan EndDrawer (Drawer dari kanan) untuk menu mobile
      endDrawer: _buildMobileDrawer(context),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Konten Homepage
            HomePageContent(),

            SizedBox(height: 40),
            FooterSection(),
          ],
        ),
      ),
    );
  }

  // Widget untuk menu navigasi di mobile
  Widget _buildMobileDrawer(BuildContext context) {
    return MobileDrawer();
  }
}

// Stateful Drawer dengan login state detection
class MobileDrawer extends StatefulWidget {
  @override
  _MobileDrawerState createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<MobileDrawer> {
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
        Navigator.pop(context); // Close drawer
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green[700]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'NGUNDUR Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isLoggedIn) ...[
                  SizedBox(height: 8),
                  Text(
                    'Hello, $_userName',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Toko'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Berita'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Blog'),
            onTap: () => Navigator.pop(context),
          ),
          Divider(),

          // Conditional menu based on login state
          if (_isLoggedIn) ...[
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('My Orders'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to orders
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to cart
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: _handleLogout,
            ),
          ] else ...[
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Masuk'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Daftar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/register');
              },
            ),
          ],
        ],
      ),
    );
  }
}
