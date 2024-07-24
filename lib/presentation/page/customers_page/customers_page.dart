import 'package:flutter/material.dart';
import 'package:waste_app/presentation/page/customers_page/methods/list_customers/list_customers.dart';
import 'package:waste_app/presentation/page/customers_page/methods/history/list_history_customers.dart';
import 'package:waste_app/presentation/page/customers_page/methods/new/new_customers.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 70, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nasabah\nBank Sampah',
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
                          height: 150,
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
                                            MaterialStateProperty.all(
                                                const Color(0xff7ABA78)),
                                        side: MaterialStateProperty.all(
                                          const BorderSide(
                                            color: Color(0xff7ABA78),
                                            width: 10,
                                          ),
                                        ),
                                        shape: MaterialStateProperty.all(
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
                                                  const NewCustomerScreen(),
                                            ));
                                      },
                                      icon: const Icon(Icons.person_add,
                                          color: Colors.white),
                                      label: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Daftar Nasabah Baru',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700),
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
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                                  child: Text(
                                    'Diperuntukkan untuk nasabah baru yang ingin menabung di Bank Sampah',
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
                                            MaterialStateProperty.all(
                                                const Color(0xff7ABA78)),
                                        side: MaterialStateProperty.all(
                                          const BorderSide(
                                            color: Color(0xff7ABA78),
                                            width: 10,
                                          ),
                                        ),
                                        shape: MaterialStateProperty.all(
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
                                                  const ListCustomers(),
                                            ));
                                      },
                                      icon: const Icon(Icons.group,
                                          color: Colors.white),
                                      label: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Nasabah',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700),
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
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  child: Text(
                                    'Berisi detail data nasabah Bank Sampah yang sudah terdaftar',
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
                                            MaterialStateProperty.all(
                                                const Color(0xff7ABA78)),
                                        side: MaterialStateProperty.all(
                                          const BorderSide(
                                            color: Color(0xff7ABA78),
                                            width: 10,
                                          ),
                                        ),
                                        shape: MaterialStateProperty.all(
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
                                                  const ListHistory(),
                                            ));
                                      },
                                      icon: const Icon(Icons.history,
                                          color: Colors.white),
                                      label: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Riwayat Menabung',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700),
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
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                  child: Text(
                                    'Berisi detail Riwayat Menabung Nasabah',
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
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 7),
            ],
          ),
        ),
      ),
    );
  }
}
