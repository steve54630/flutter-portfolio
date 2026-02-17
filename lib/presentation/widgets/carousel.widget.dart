import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<String> images;

  const Carousel({super.key, required this.images});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Le slider d'images
        PageView.builder(
          controller: _controller,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemCount: widget.images.length,
          itemBuilder: (context, index) => Image.asset(
            widget.images[index],
            fit: BoxFit.contain,
            errorBuilder: (context, _, _) => Container(color: Colors.grey[900]),
          ),
        ),

        // Navigation (Flèches) - Apparaît si > 1 image
        if (widget.images.length > 1) ...[
          _buildNavButton(
            icon: Icons.arrow_back_ios_new,
            left: 8,
            onPressed: () => _controller.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          _buildNavButton(
            icon: Icons.arrow_forward_ios,
            right: 8,
            onPressed: () => _controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),

          // Indicateur de points (Dots)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    double? left,
    double? right,
    required VoidCallback onPressed,
  }) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: left,
      right: right,
      child: Center(
        child: IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          style: IconButton.styleFrom(backgroundColor: Colors.black38),
        ),
      ),
    );
  }
}
