import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/homepage.dart'; // <-- tambah ini
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
  final padding = EdgeInsets.symmetric(horizontal: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SizedBox(height: 24),

            // ===== MASUKKAN HOMEPAGE SEBENARNYA DI SINI =====
            HomePageContent(),

            SizedBox(height: 40),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}
