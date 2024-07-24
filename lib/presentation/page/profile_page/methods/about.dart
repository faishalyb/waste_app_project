import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tentang Aplikasi',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '"WasteApp" adalah aplikasi inovatif yang dirancang untuk memberdayakan pengelola bank sampah dalam menjaga lingkungan dengan menyediakan fitur deteksi sampah dan pencatatan transaksi sampah di bank sampah.\n\n Aplikasi ini menggunakan teknologi pengenalan gambar dan kecerdasan buatan untuk mengidentifikasi jenis sampah dan rekomendasi recycle sampah.',
              style: TextStyle(height: 1.7),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              'Development Team:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 180,
                  width: 102,
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/png/fix_faishal.png'),
                      const Text(
                        'Faishal Yusuf',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Image.asset('assets/png/fe.png'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 102,
                  height: 180,
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/png/fix_sofvi.png'),
                      const Text(
                        'Sofviyah Aprilliani',
                        style: TextStyle(fontSize: 11),
                      ),
                      const SizedBox(height: 9),
                      Image.asset('assets/png/ml.png'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 102,
                  height: 180,
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/png/fix_ikhwan.png'),
                      const Text(
                        'Ikhwan Nashir',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/png/be.png',
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomSheet: const Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Text(
          '© 2024 Rancang Bangun Aplikasi Bank Sampah berbasis Mobile Menggunakan Metode Object Detection\n',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }
}
