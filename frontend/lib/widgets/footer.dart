import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Tentukan lebar layar untuk responsif (misal di bawah 600 dianggap mobile)
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      // Ketinggian dinamis di mobile, tetap 220 di desktop
      height: isMobile ? null : 220, 
      width: double.infinity,
      color: Colors.green, // background full hijau
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 28, vertical: 24),
        child: isMobile
            ? Column( // Gunakan Column untuk Mobile
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildFooterContent(isMobile),
              )
            : Row( // Gunakan Row untuk Desktop/Web
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildFooterContent(isMobile),
              ),
      ),
    );
  }
  
  // Fungsi pembantu untuk membangun konten footer
  List<Widget> _buildFooterContent(bool isMobile) {
    return [
      // Kolom kiri (Teks Kontak/Alamat)
      Expanded(
        flex: isMobile ? 0 : 1, // Hapus Expanded di Mobile agar Column beradaptasi
        child: Column(
          // Text alignment berubah di mobile
          crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
              // Text alignment di tengah di mobile
              textAlign: isMobile ? TextAlign.center : TextAlign.start, 
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
      
      // Spasi vertikal di mobile, horizontal di desktop
      SizedBox(height: isMobile ? 20 : 0, width: isMobile ? 0 : 20), 

      // Logo kanan
      Align(
        alignment: isMobile ? Alignment.center : Alignment.topRight,
        child: Opacity(
          opacity: 0.95,
          child: Image.asset(
            'assets/images/logo-ngundur.png',
            height: 60,
            errorBuilder: (c, e, s) => SizedBox.shrink(),
          ),
        ),
      ),
    ];
  }
}