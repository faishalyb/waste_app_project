import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WasteItemRow extends StatefulWidget {
  final int index;
  final List<String> wasteTypes;
  final String selectedWasteType; // Add this line
  final Function(String) onWasteTypeChanged;
  final Function(String) onAmountChanged;
  final Function(int) onDelete;
  final Function(int, double) onTotalChanged;

  const WasteItemRow({
    super.key,
    required this.index,
    required this.wasteTypes,
    required this.selectedWasteType, // Add this line
    required this.onWasteTypeChanged,
    required this.onAmountChanged,
    required this.onDelete,
    required this.onTotalChanged,
  });

  @override
  State<WasteItemRow> createState() => _WasteItemRowState();
}

class _WasteItemRowState extends State<WasteItemRow> {
  TextEditingController wasteTypeController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  OverlayEntry? _overlayEntry;

  List<String> wasteTypes = [];
  Map<String, int> wasteTypePrices = {}; // Map to store waste type and prices

  @override
  void initState() {
    super.initState();
    fetchWasteTypes();
    wasteTypeController.text = widget.selectedWasteType; // Add this line
  }

  Future<void> fetchWasteTypes() async {
    final response = await http
        .get(Uri.parse('${dotenv.env['BASE_URL_BACKEND']}/wastetypes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        wasteTypes = data.map((e) => e['name'] as String).toList();
        wasteTypes.sort();
        wasteTypePrices = Map.fromIterable(
          data,
          key: (e) => e['name'] as String,
          value: (e) {
            if (e['pricePer100Gram'] is int) {
              return e['pricePer100Gram'] as int;
            } else if (e['pricePer100Gram'] is String) {
              return int.tryParse(e['pricePer100Gram']) ?? 0;
            } else {
              return 0;
            }
          },
        );
      });
    } else {
      setState(() {});
    }
  }

  double calculateTotal() {
    if (!wasteTypePrices.containsKey(widget.selectedWasteType)) return 0;

    double amount =
        double.tryParse(amountController.text) ?? 0; // Handle invalid input
    double amountInGrams = amount * 1000; // Convert kg to grams
    return (wasteTypePrices[widget.selectedWasteType]! / 100) *
        amountInGrams; // Calculate total
  }

  void _showDropDownWaste(BuildContext context, RenderBox renderBox) {
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
              children: wasteTypes.map((String wasteType) {
                return ListTile(
                  title: Text(wasteType),
                  onTap: () {
                    setState(() {
                      wasteTypeController.text = wasteType;
                      widget.onWasteTypeChanged(wasteType);
                      widget.onTotalChanged(widget.index, calculateTotal());
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

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter =
        NumberFormat('#,##0', 'id_ID'); // FORMAT RIBUAN PEMISAH
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  _showDropDownWaste(context, renderBox);
                },
                child: AbsorbPointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffeeeeee),
                    ),
                    child: SizedBox(
                      width: 195,
                      child: TextField(
                        style: const TextStyle(fontSize: 14),
                        controller: wasteTypeController,
                        decoration: InputDecoration(
                          hintText: 'Pilih Sampah',
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          hintStyle: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffeeeeee),
            ),
            child: SizedBox(
              width: 70,
              child: TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'KG',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                onChanged: (value) {
                  widget.onAmountChanged(value);
                  widget.onTotalChanged(
                    widget.index,
                    calculateTotal(),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 80,
              child: Text(
                'Rp${formatter.format(calculateTotal())}',
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
