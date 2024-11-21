import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:waste_app/domain/waste.dart';
import 'package:waste_app/presentation/page/home_page/methods/jual_sampah.dart';
import 'package:waste_app/presentation/page/home_page/methods/riwayat.dart';

class WasteCharts extends StatefulWidget {
  const WasteCharts({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WasteChartsState createState() => _WasteChartsState();
}

class _WasteChartsState extends State<WasteCharts> {
  late Future<Map<String, dynamic>> futureData;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    futureData = fetchWasteData();
  }

  Future<Map<String, dynamic>> fetchWasteData() async {
    final wasteAmounts = await Waste().getWasteAmounts();
    final wasteTypes = await Waste().getWaste();

    Map<String, String> wasteIdToName = {
      for (var type in wasteTypes) type['id']: type['name']
    };

    // Sort waste amounts by totalAmount in descending order
    wasteAmounts.sort((a, b) => b['totalAmount'].compareTo(a['totalAmount']));

    return {'wasteAmounts': wasteAmounts, 'wasteIdToName': wasteIdToName};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        } else {
          List<dynamic> wasteData = snapshot.data!['wasteAmounts'];
          Map<String, String> wasteIdToName = snapshot.data!['wasteIdToName'];

          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stok Sampah',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Berikut adalah stok sampah yang dimiliki',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: List.generate(wasteData.length, (index) {
                              var data = wasteData[index];
                              double value = data['totalAmount'].toDouble();
                              return PieChartSectionData(
                                value: value,
                                color: _getColor(index),
                                radius: 80,
                                title: value.toStringAsFixed(1),
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 80, bottom: 30, left: 5, right: 5),
                          child: SizedBox(
                            width:
                                wasteData.length * 80, // Adjust width as needed
                            child: BarChart(
                              BarChartData(
                                barGroups:
                                    List.generate(wasteData.length, (index) {
                                  var data = wasteData[index];
                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        fromY: 0,
                                        toY: data['totalAmount'].toDouble(),
                                        color: _getColor(index),
                                        width: 60,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                    showingTooltipIndicators:
                                        touchedIndex == index ? [0] : [],
                                  );
                                }),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(fontSize: 12),
                                          textAlign: TextAlign.left,
                                        );
                                      },
                                      interval: 50, // Set interval to 50
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        if (index < 0 ||
                                            index >= wasteData.length) {
                                          return const Text('');
                                        }
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Transform.rotate(
                                            angle: 350 * (pi / 180),
                                            child: Text(
                                              wasteIdToName[wasteData[index]
                                                      ['wasteTypeId']] ??
                                                  'Unknown',
                                              style: const TextStyle(
                                                  fontSize:
                                                      12), // Adjust text style as needed
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                gridData: const FlGridData(
                                    show: true), // Optionally hide grid
                                borderData: FlBorderData(
                                    show: false), // Optionally hide border
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                      String wasteName = wasteIdToName[
                                              wasteData[group.x.toInt()]
                                                  ['wasteTypeId']] ??
                                          'Unknown';
                                      return BarTooltipItem(
                                        '$wasteName\n',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '${rod.toY.toStringAsFixed(1)} Kg',
                                            style: const TextStyle(
                                              color: Colors.yellow,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  touchCallback:
                                      (FlTouchEvent event, barTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          barTouchResponse == null ||
                                          barTouchResponse.spot == null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = barTouchResponse
                                          .spot!.touchedBarGroupIndex;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: wasteData.length,
                      itemBuilder: (context, index) {
                        var data = wasteData[index];
                        String wasteName =
                            wasteIdToName[data['wasteTypeId']] ?? 'Unknown';
                        String amount = data['totalAmount'].toStringAsFixed(1);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    wasteName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$amount Kg',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              if (index == wasteData.length - 1)
                                const SizedBox(height: 10)
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WasteHistory()));
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  const Color(0xFF7ABA78)),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Riwayat',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 150,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SellWaste(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                const Color(0xffE66776),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Jual/Setor',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Color _getColor(int index) {
    const List<Color> colorPalette = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.yellow,
      Colors.lightGreen,
      Colors.redAccent,
      Colors.amber,
      Colors.greenAccent,
      Colors.pink,
      Colors.cyan,
      Colors.deepPurple,
      Colors.lightGreenAccent
    ];
    return colorPalette[index % colorPalette.length];
  }
}
