import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waste_app/presentation/page/saving_page/methods/balance/customers_balance.dart';
import 'package:waste_app/presentation/page/saving_page/methods/saving/saving_waste.dart';
import 'package:waste_app/presentation/page/saving_page/methods/waste/waste_list.dart';

class SavingPageScreen extends StatelessWidget {
  const SavingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 70, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tabung\nBank Sampah',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 10),
                  SizedBox(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 130,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0Xff7ABA78),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                        height: 50,
                                        child: OutlinedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    const Color(0xff7ABA78)),
                                            side: WidgetStateProperty.all(
                                              const BorderSide(
                                                color: Color(0xff7ABA78),
                                                width: 10,
                                              ),
                                            ),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SavingWasteScreen(),
                                                ));
                                          },
                                          icon: const Icon(
                                              Icons.system_update_tv_rounded,
                                              color: Colors.white),
                                          label: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Menabung Sampah',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      child: Text(
                                        'Diperuntukkan untuk nasabah yang ingin menabung di bank sampah',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 130,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0Xff7ABA78),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                        height: 50,
                                        child: OutlinedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    const Color(0xff7ABA78)),
                                            side: WidgetStateProperty.all(
                                              const BorderSide(
                                                color: Color(0xff7ABA78),
                                                width: 10,
                                              ),
                                            ),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CustomersBalance(),
                                                ));
                                          },
                                          icon: const Icon(
                                              Icons.monetization_on_outlined,
                                              color: Colors.white),
                                          label: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Saldo Nasabah',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      child: Text(
                                        'Berisi detail data nasabah bank sampah yang sudah terdaftar ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 130,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0Xff7ABA78),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                        height: 50,
                                        child: OutlinedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    const Color(0xff7ABA78)),
                                            side: WidgetStateProperty.all(
                                              const BorderSide(
                                                color: Color(0xff7ABA78),
                                                width: 10,
                                              ),
                                            ),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WasteList(),
                                                ));
                                          },
                                          icon: const Icon(Icons.recycling,
                                              color: Colors.white),
                                          label: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Jenis Sampah',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      child: Text(
                                        'Pengelola dapat mengatur jenis sampah di sini',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
