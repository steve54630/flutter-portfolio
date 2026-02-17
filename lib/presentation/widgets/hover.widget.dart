import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  const HoverCard({super.key, required this.child});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Calcul de la transformation (on monte de 8 pixels)
    final hoveredTransform = Matrix4.identity()
      ..translateByDouble(0.0, -8.0, 0.0, 0.0);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: isHovered ? hoveredTransform : Matrix4.identity(),
        child: PhysicalModel(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          elevation: isHovered ? 12 : 4, // L'ombre s'accentue au survol
          shadowColor: Colors.black.withValues(alpha: .2),
          child: widget.child,
        ),
      ),
    );
  }
}
