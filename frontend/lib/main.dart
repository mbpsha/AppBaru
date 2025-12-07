import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/homepage.dart'; 
import 'services/api_client.dart';
import 'screens/api_test_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green[700]),
            child: Text(
              'NGUNDUR Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(leading: Icon(Icons.home), title: Text('Home'), onTap: () => Navigator.pop(context)),
          ListTile(leading: Icon(Icons.store), title: Text('Toko'), onTap: () => Navigator.pop(context)),
          ListTile(leading: Icon(Icons.article), title: Text('Berita'), onTap: () => Navigator.pop(context)),
          ListTile(leading: Icon(Icons.info), title: Text('Tentang'), onTap: () => Navigator.pop(context)),
          ListTile(leading: Icon(Icons.library_books), title: Text('Blog'), onTap: () => Navigator.pop(context)),
          Divider(),
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
          // Jika sudah login, tambahkan item menu profil dan logout di sini
        ],
      ),
    );
  }
}