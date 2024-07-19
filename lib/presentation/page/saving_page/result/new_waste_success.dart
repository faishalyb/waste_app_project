import 'package:flutter/material.dart';

class NewWasteSuccess extends StatelessWidget {
  const NewWasteSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Image.asset("assets/png/berhasil_tambah_sampah.png"),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Berhasil Menambah \nJenis Sampah!',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Berhasil Menambah Jenis Sampah, Pengelola dapat menggunakannya di Tabung Sampah',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                    const BorderSide(color: Color(0xFF7ABA78), width: 2.5)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
              ),
              child: const Text("Kembali",
                  style: TextStyle(
                      color: Color(0xFF7ABA78),
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
