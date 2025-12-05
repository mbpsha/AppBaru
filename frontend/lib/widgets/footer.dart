import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.green, // background full hijau
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolom kiri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NGUNDUR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Jl. Ringroad Barat, Dewangan, Banyuraden,\nGamping, Sleman, Daerah Istimewa Yogyakarta',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone +62 000-0000-000',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'WA +62 000-0000-000',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hours Senin-Jumat 09.00-16.00',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            SizedBox(width: 20),

            // Logo kanan
            Align(
              alignment: Alignment.topRight,
              child: Opacity(
                opacity: 0.95,
                child: Image.asset(
                  'assets/images/logo-ngundur.png',
                  height: 60,
                  errorBuilder: (c, e, s) => SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
