import 'package:flutter/material.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeroSection(),
        SizedBox(height: 40),
        _Artikel3(), // Sudah responsif
        SizedBox(height: 40),
        _KeunggulanAlat(), // Sudah responsif
        SizedBox(height: 40),
        _FiturBawah(), // Sudah responsif
      ],
    );
  }
}

//
// ========================= HERO SECTION =========================
//

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Stack(
      children: [
        // background
        Container(
          height: 420,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg-homepage.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Text hero
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stech Smart\nGarden",
                  style: TextStyle(
                    // Ukuran font lebih kecil di mobile
                    fontSize: isMobile ? 36 : 44, 
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  "Sistem irigasi otomatis berbasis IoT yang membantu\n"
                  "petani dan masyarakat dalam mengelola air secara efisien.",
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 22),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white, 
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 12,
                        ),
                      ),
                      child: Text("Beli Sekarang"),
                    ),
                    SizedBox(width: 14),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Baca Lengkap",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//
// ========================= 3 ARTIKEL (RESPONSIVE) ================
//

class _Artikel3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    // List konten artikel
    final articles = [
      _ArtikelCard(
        img: "assets/images/keunggulan-alat-0.png",
        title: "Indonesia Dorong Pertanian Ramah Lingkungan dengan Teknologi IoT",
      ),
      _ArtikelCard(
        img: "assets/images/keunggulan-alat-1.png",
        title: "Petani Sayuran Mulai Terapkan Irigasi Otomatis untuk Hemat Air",
      ),
      _ArtikelCard(
        img: "assets/images/keunggulan-alat-2.png",
        title: "Tren Pertanian Urban: Berkebun di Lahan Sempit dengan Smart Garden",
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: isMobile
          ? Wrap( // Gunakan Wrap di Mobile agar bisa turun baris otomatis
              spacing: 20, 
              runSpacing: 20, 
              alignment: WrapAlignment.center, 
              children: articles,
            )
          : Row( // Gunakan Row di Desktop
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: articles,
            ),
    );
  }
}

class _ArtikelCard extends StatelessWidget {
  final String img;
  final String title;

  const _ArtikelCard({required this.img, required this.title});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Container(
      // Atur lebar fleksibel di mobile (misal 300)
      width: isMobile ? 300 : 250, 
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(img, height: 150, fit: BoxFit.cover), 
          ),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

//
// ========================= KEUNGGULAN ALAT (RESPONSIVE) =========================
//

class _KeunggulanAlat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 226, 247, 227),
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Keunggulan Alat",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.green[900],
            ),
          ),
          SizedBox(height: 30),

          _KeunggulanCard(
            image: "assets/images/keunggulan-alat-0.png",
            title: "Modular & Scalable",
            desc:
                "Stech Smart Garden dirancang dengan konsep modular dan scalable, sehingga mudah ditambahkan sensor atau fitur lain sesuai kebutuhan pengguna. Selain sensor kelembaban tanah yang sudah menjadi inti sistem, pengguna dapat menambahkan sensor suhu, kelembaban udara, intensitas cahaya, hingga pH dan nutrisi tanah untuk pemantauan yang lebih komprehensif. Seluruh sensor ini dapat diintegrasikan dengan dashboard web yang sudah tersedia, sehingga data tambahan langsung bisa divisualisasikan secara real-time.",
          ),

          SizedBox(height: 26),

          _KeunggulanCard(
            image: "assets/images/keunggulan-alat-1.png",
            title: "Hemat Energi",
            desc:
                "Varian Stech Smart Garden dengan panel surya mendukung operasi mandiri karena memanfaatkan energi matahari sebagai sumber daya utama. Dengan sistem ini, perangkat dapat berfungsi secara berkelanjutan tanpa bergantung pada listrik PLN, sehingga sangat cocok digunakan di daerah yang minim pasokan listrik atau di lahan terbuka yang jauh dari jaringan listrik. Selain lebih hemat biaya operasional, penggunaan panel surya juga menjadikan sistem ini ramah lingkungan karena mengurangi jejak karbon dan memaksimalkan pemanfaatan energi terbarukan.",
            reverse: true,
          ),

          SizedBox(height: 26),

          _KeunggulanCard(
            image: "assets/images/keunggulan-alat-2.png",
            title: "Open Source & Edukatif",
            desc:
                "Stech Smart Garden dilengkapi dengan buku panduan perakitan dan source code yang dapat digunakan sebagai media pembelajaran IoT. Dengan adanya panduan ini, pengguna tidak hanya mendapatkan produk siap pakai, tetapi juga bisa memahami alur kerja sistem mulai dari instalasi komponen, integrasi sensor, hingga pengelolaan data pada dashboard. Source code yang disertakan bersifat terbuka sehingga dapat dipelajari, dimodifikasi, dan dikembangkan lebih lanjut sesuai kebutuhan, menjadikan produk ini tidak hanya bermanfaat secara praktis, tetapi juga edukatif bagi pelajar, mahasiswa, maupun siapa saja yang ingin mendalami teknologi IoT di bidang pertanian.",
          ),
        ],
      ),
    );
  }
}

class _KeunggulanCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final bool reverse;

  const _KeunggulanCard({
    required this.image,
    required this.title,
    required this.desc,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    // Konten teks
    final textContent = Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        // Alignment teks menyesuaikan mobile atau reverse
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center 
            : (reverse ? CrossAxisAlignment.end : CrossAxisAlignment.start), 
        children: [
          Text(
            title,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            desc,
            // Alignment paragraf menyesuaikan
            textAlign: isMobile ? TextAlign.center : TextAlign.justify, 
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );

    // Konten gambar
    final imageContent = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        image,
        // Lebar gambar penuh di mobile
        width: isMobile ? double.infinity : 340, 
        height: 200, 
        fit: BoxFit.cover,
      ),
    );

    // List urutan konten
    final content = [
      isMobile ? textContent : Expanded(child: textContent), // Teks (Expanded di desktop)
      SizedBox(height: isMobile ? 16 : 0), // Spasi vertikal di mobile
      imageContent, // Gambar
    ];

    if (isMobile) {
      // Di mobile, gunakan Column
      return Column(
        children: content,
      );
    } else {
      // Di desktop, gunakan Row
      return Row(
        // Perhatikan urutan konten jika reverse
        children: reverse ? content.reversed.toList() : content,
      );
    }
  }
}

//
// ========================= FOTO BAWAH (RESPONSIVE) =========================
//

class _FiturBawah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final items = [
      _FiturItem("Monitoring\nReal time"),
      _FiturItem("Irigasi\nOtomatis"),
      _FiturItem("Dashboard\nWeb"),
    ];

    // Gunakan Column di mobile, Row di desktop
    return isMobile
        ? Column(children: items) 
        : Row(children: items); 
  }
}

class _FiturItem extends StatelessWidget {
  final String text;
  const _FiturItem(this.text);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Di mobile, setiap item adalah widget independen. Di desktop menggunakan Expanded.
    return isMobile
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0), 
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/foto-bawah-3.png",
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  height: 150, // Tetapkan tinggi di mobile agar konsisten
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Expanded( // Di desktop gunakan Expanded
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/foto-bawah-3.png",
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}