// ...existing code...
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
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

            // tombol di kanan
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
                foregroundColor: MaterialStateProperty.all(Colors.green[700]),
              ),
              child: Text('Daftar'),
            ),
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