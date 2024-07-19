import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:waste_app/presentation/page/welcoming_page/welcoming_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: <Widget>[
              PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  Center(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SvgPicture.asset("assets/svg/onboarding1.svg"),
                              const SizedBox(height: 30),
                              const Text(
                                "Jadilah bagian dari aksi lindungi Bumi dengan memanfaatkan dan mengelola sampah dengan benar!",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SvgPicture.asset("assets/svg/onboarding2.svg"),
                              const SizedBox(height: 30),
                              const Text(
                                "Setorkan sampahmu di Bank Sampah terdekat mulai dari sekarang!",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text(
                                  "Mari menabung dengan sampah disekitar kita!",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 30),
                              SvgPicture.asset("assets/svg/onboarding3.svg"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 180,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF7FB77E),
                            ),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(
                                100, 40)), // Set custom width and height
                          ),
                          onPressed: () {
                            if (_currentPage < 2) {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.ease);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const WelcomingPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 1000),
                                ),
                              );
                            }
                          },
                          child: Text(
                            _currentPage < 2 ? "Berikutnya" : "Selesai",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                left: 150,
                bottom: 60,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3, // Number of pages in the PageView
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.teal,
                    dotColor: Colors.grey.shade300,
                    dotWidth: 7,
                    dotHeight: 7,
                    spacing: 15,
                    // verticalOffset: 10
                  ),
                ),
              )
            ],
          )),
    );
  }
}
