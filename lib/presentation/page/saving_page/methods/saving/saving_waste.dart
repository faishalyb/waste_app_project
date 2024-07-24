import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:waste_app/domain/ml.dart';
import 'package:waste_app/presentation/page/saving_page/result/saving_success.dart';
import 'package:waste_app/presentation/widgets/date_picker.dart';
import 'package:waste_app/presentation/widgets/text_fields_customers.dart';
import 'package:waste_app/presentation/widgets/waste_item_row.dart';
import 'package:waste_app/presentation/widgets/zoomable_view.dart';
import 'package:http/http.dart' as http;

class SavingWasteScreen extends StatefulWidget {
  const SavingWasteScreen({super.key});

  @override
  State<SavingWasteScreen> createState() => _SavingWasteScreenState();
}

class _SavingWasteScreenState extends State<SavingWasteScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String? _errorMessage;
  OverlayEntry? _overlayEntry;
  List<String> names = [];
  List<Map<String, String>> wasteTypes = [];
  List<Map<String, dynamic>> wasteItems = [];
  Map<int, double> itemTotals = {};
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
      File detectedImage = await mlService.detectTrash(inputImageFile);
      List<Prediction> predictions = await mlService.detectText(inputImageFile);

      setState(() {
        _imageFile = detectedImage;
        _predictions = predictions;
        wasteItems.clear(); // Clear existing items

        // This line is the key fix: Always add the initial empty row first
        wasteItems.add({'wasteType': '', 'amount': ''});

        // Fill in additional rows based on predictions
        if (predictions.isNotEmpty) {
          wasteItems.addAll(
              predictions.map((p) => {'wasteType': p.label, 'amount': ''}));
        }
      });
    } catch (e) {
      print('Error during trash detection: $e');
      // Add user-facing error handling here (e.g., Snackbar)
    } finally {
      EasyLoading.dismiss();
    }
  }

// PENAMBAHAN WASTE ITEM ROW
  void addWasteItem() {
    setState(() {
      wasteItems.add({'wasteType': '', 'amount': ''});
    });
  }

// PENGHAPUSAN WASTE ITEM
  void deleteWasteItem(int index) {
    setState(() {
      wasteItems.removeAt(index);
      itemTotals.remove(index);
      calculateOverallTotal();
    });
  }

// HAPUS WASTE ITEM TERAKHIR
  void deleteLastWasteItem() {
    if (wasteItems.isNotEmpty) {
      setState(() {
        int lastIndex = wasteItems.length - 1;
        wasteItems.removeLast();
        itemTotals.remove(lastIndex);
        calculateOverallTotal();
      });
    }
  }

// PENJUMLAHAN PERITEM
  void updateItemTotal(int index, double total) {
    setState(() {
      itemTotals[index] = total;
      calculateOverallTotal();
    });
  }

// PENJUMLAHAN SUM TOTAL ITEM
  double calculateOverallTotal() {
    double total = 0;
    itemTotals.forEach((_, value) {
      total += value;
    });
    return total;
  }

// MEMBERSIHKAN FORM
  void _clearForm() {
    setState(() {
      nameController.clear();
      dateController.clear();
      wasteItems.clear();
      wasteItems.add({'wasteType': '', 'amount': ''});
      itemTotals.clear();
      _errorMessage = null;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchName();
    fetchWasteTypes();
    wasteItems.add({'wasteType': '', 'amount': ''}); // Start with one row
  }

// MENDAPATKAN NAMA BASED ON GET /NASABAH
  Future<void> fetchName() async {
    final response =
        await http.get(Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/nasabah'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        names = data.map((e) => e['name'] as String).toList();
        names.sort();
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load data';
      });
    }
  }

// MENDAPATKAN WASTE TYPE
  Future<void> fetchWasteTypes() async {
    final response = await http
        .get(Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/wastetypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        wasteTypes = data
            .map((e) => {
                  'id': e['id'] as String,
                  'name': e['name'] as String,
                })
            .toList();
        wasteTypes.sort((a, b) => a['name']!.compareTo(b['name']!));
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load data';
      });
    }
  }

// DROPDOWN NAME
  void _showDropdownName(BuildContext context, RenderBox renderBox) {
    final overlay = Overlay.of(context);
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: names.map((String name) {
                return ListTile(
                  title: Text(name),
                  onTap: () {
                    setState(() {
                      nameController.text = name;
                    });
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

// FUNGSI UNTUK OVERLAY DROPDOWN WHEN PREVIOUS PAGE
  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  Future<void> _submitDeposits() async {
    EasyLoading.show(status: 'Loading...');
    if (nameController.text.isEmpty || dateController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Tolong isi Semua Data!';
      });
      EasyLoading.dismiss();
      return;
    }
    List<Map<String, dynamic>> deposits = [];

    // Filter out empty waste items
    for (var item in wasteItems) {
      if (item['wasteType'].isNotEmpty && item['amount'].isNotEmpty) {
        final selectedWasteType = wasteTypes
            .firstWhere((wasteType) => wasteType['name'] == item['wasteType']);
        deposits.add({
          'wasteTypeId': selectedWasteType['id'],
          'amount': double.parse(item['amount']),
        });
      }
    }
    // Additional Validation: Check if any valid waste items exist
    if (deposits.isEmpty) {
      setState(() {
        _errorMessage = 'Tolong isi setidaknya satu jenis sampah dan jumlah!';
      });
      EasyLoading.dismiss(); // Dismiss EasyLoading on error
      return; // Exit the function if no valid waste items exist
    }

    final response = await http.post(
      Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/tabung'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'date': dateController.text,
        'deposits': deposits,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SavingSuccess(),
          ));
      _clearForm();
    } else {
      setState(() {
        _errorMessage = 'Failed to save deposits';
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat(
        '#,##0', 'id_ID'); // FORMAT RIBUAN PEMISAH INDONESIA LOCALIZATION

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tabung Sampah',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (_predictions.isEmpty)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gunakan fitur Pindai untuk mendeteksi jenis dan jumlah sampah',
                  ),
                ],
              )
            else
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hasil Deteksi Sampah',
                    style: TextStyle(),
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
                        _predictions.map((p) => p.label).join('\n'),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
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
                  const SizedBox(height: 10),
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
              ),
            const SizedBox(height: 10),
            const Text(
              'Nama',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    _showDropdownName(context, renderBox);
                  },
                  child: AbsorbPointer(
                    child: WasteAppTextFieldsCustomer(
                      hintText: 'Nama Nasabah',
                      controller: nameController,
                      suffixIcon: true,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Tanggal',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            WasteAppDatePicker(
              hintText: 'DD/MM/YYYY',
              controller: dateController,
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160,
                  child: Text(
                    'Jenis Sampah',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    'Berat',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'Harga',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            for (int i = 1; i < wasteItems.length; i++)
              WasteItemRow(
                index: i,
                wasteTypes: wasteTypes.map((e) => e['name']!).toList(),
                selectedWasteType: wasteItems[i]['wasteType']!,
                onWasteTypeChanged: (value) {
                  setState(() {
                    wasteItems[i]['wasteType'] = value;
                  });
                },
                onAmountChanged: (value) {
                  setState(() {
                    wasteItems[i]['amount'] = value;
                  });
                },
                onDelete: deleteWasteItem,
                onTotalChanged: updateItemTotal,
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.green),
                  ),
                  child: TextButton(
                    onPressed: addWasteItem,
                    child: const Text(
                      '+ Tambah Sampah',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.red)),
                  child: TextButton(
                    onPressed: deleteLastWasteItem,
                    child: const Text(
                      '- Hapus Sampah',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 150),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ]),
        child: BottomAppBar(
          elevation: 0,
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Rp${formatter.format(calculateOverallTotal())}', // IMPLEMENTASI
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff7ABA78),
                  ),
                  child: TextButton(
                    onPressed: _submitDeposits,
                    child: const Text(
                      'Tabung',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
