import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:waste_app/presentation/widgets/image_view.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final List<String> images = [
    'assets/png/cibunut1.png',
    'assets/png/cibunut2.png',
    'assets/png/cibunut3.png',
    'assets/png/cibunut4.png',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index, _) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageView(imagePath: images[index]),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ));
          },
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            onPageChanged: (index, _) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => _buildDot(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: _currentIndex == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentIndex == index ? const Color(0xFF7FB77E) : Colors.grey,
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}
