import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailHistory extends StatefulWidget {
  final Map<String, dynamic> nasabah;

  const DetailHistory({Key? key, required this.nasabah}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailHistoryState createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistory> {
  Map<String, String> wasteTypes = {};
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWasteTypes();
  }

// MENGAMBIL DATA TIPE SAMPAH
  Future<void> fetchWasteTypes() async {
    final response = await http
        .get(Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/wastetypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        wasteTypes = {
          for (var e in data) e['id'] as String: e['name'] as String,
        };
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Menabung',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Nama',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text('${widget.nasabah['name']}'),
            const SizedBox(height: 20),
            const Text(
              'Tanggal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text('${widget.nasabah['date']}'),
            const SizedBox(height: 20),
            const Text(
              'Berat dan Jenis Sampah',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.nasabah['deposits']
                  .map<Widget>((deposit) => Row(
                        children: [
                          Text(
                              '${deposit['amount']} kg ${wasteTypes[deposit['wasteTypeId']]}'),
                          const SizedBox(width: 50),
                        ],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Debit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text('Rp${widget.nasabah['totalBalance']}'),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
