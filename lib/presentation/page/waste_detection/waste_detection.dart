import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waste_app/domain/ml.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:waste_app/presentation/widgets/zoomable_view.dart';
import 'package:waste_app/presentation/page/waste_detection/methods/models.dart';
import 'package:waste_app/presentation/page/waste_detection/methods/recomendation.dart';

class WasteDetection extends StatefulWidget {
  const WasteDetection({super.key});

  @override
  State<WasteDetection> createState() => _WasteDetectionState();
}

class _WasteDetectionState extends State<WasteDetection> {
  File? _imageFile;
  final MLService mlService = MLService();
  List<Prediction> _predictions = [];

// MENGAMBIL GAMBAR DENGAN MEMAKAI SUMBER DARI KAMERA
  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      await _detectTrash(_imageFile!);
    }
  }

// MENGAMBIL GAMBAR DENGAN MEMAKAI SUMBER DARI GALERI
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      await _detectTrash(_imageFile!);
    }
  }

// MENDETEKSI SAMPAH DENGAN API DETECTTRASH
  Future<void> _detectTrash(File inputImageFile) async {
    EasyLoading.show(status: "Loading");
    try {
      // Use MLService to detect trash and get the processed image
      File detectedImage = await mlService.detectTrash(inputImageFile);
      List<Prediction> predictions = await mlService.detectText(inputImageFile);

      setState(() {
        _imageFile = detectedImage;
        _predictions = predictions;
      });
    } catch (e) {
      // Handle errors from MLService
      // ignore: avoid_print
      print('Error: $e');
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_predictions.isEmpty)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deteksi Sampah',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Gunakan fitur Pindai untuk mendeteksi jenis dan jumlah sampah',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              else
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Deteksi Sampah',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Berikut adalah Hasil Deteksi Sampah yang sudah diunggah',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_imageFile != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ZoomableImageView(imageFile: _imageFile!),
                        ),
                      );
                    }
                  },
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: _imageFile != null
                        ? Image.file(_imageFile!)
                        : Image.asset(
                            'assets/png/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_predictions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Sampah terdeteksi:',
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: const BoxDecoration(color: Color(0XFFF6F4BD)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          _predictions.join('\n'),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (_predictions.isEmpty)
                Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 171,
                        height: 45,
                        child: OutlinedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff7ABA78)),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Color(0xff7ABA78),
                                width: 2,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await _takePicture();
                          },
                          icon: const Icon(Icons.camera_alt_sharp,
                              color: Colors.white),
                          label: const Text(
                            'Ambil Foto',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: SizedBox(
                        width: 171,
                        height: 45,
                        child: OutlinedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Color(0xff7ABA78),
                                width: 2,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await _pickImage();
                          },
                          icon: const Icon(Icons.file_upload_outlined,
                              color: Color(0xff7ABA78)),
                          label: const Text(
                            'Pilih foto',
                            style: TextStyle(
                              color: Color(0xff7ABA78),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              else
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff7ABA78),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RecomendationScreen(
                            recommendations: Models.fromLabels(
                                _predictions.map((p) => p.label).toList()),
                          );
                        }));
                      },
                      child: const Text(
                        'Rekomendasi Pengolahan',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
