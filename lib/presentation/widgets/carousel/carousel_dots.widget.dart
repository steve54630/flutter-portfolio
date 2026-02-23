import 'package:flutter/material.dart';

class CarouselIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;

  const CarouselIndicators({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: currentIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? Colors.redAccent : Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
