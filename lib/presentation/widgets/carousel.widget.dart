import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_steve/presentation/widgets/carousel/carousel_arrow.widget.dart';
import 'package:portfolio_steve/presentation/widgets/carousel/carousel_dots.widget.dart';

class Carousel extends StatefulWidget {
  final List<String> images;

  const Carousel({super.key, required this.images});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo({required bool isNext}) {
    final targetPage = isNext ? _currentPage + 1 : _currentPage - 1;
    if (targetPage >= 0 && targetPage < widget.images.length) {
      _controller.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _buildImageSlider()),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CarouselIndicators(
              count: widget.images.length,
              currentIndex: _currentPage,
            ),
          ),
      ],
    );
  }

  Widget _buildImageSlider() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.images.length,
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(widget.images[index], fit: BoxFit.contain),
            ),
          ),
          if (widget.images.length > 1) ...[
            CarouselNavButton(
              icon: Icons.arrow_back_ios_new,
              left: 12,
              onPressed: () => _animateTo(isNext: false),
            ),
            CarouselNavButton(
              icon: Icons.arrow_forward_ios,
              right: 12,
              onPressed: () => _animateTo(isNext: true),
            ),
          ],
        ],
      ),
    );
  }
}
