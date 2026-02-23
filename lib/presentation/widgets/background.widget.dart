import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio_steve/domain/entities/particules.entity.dart';
import 'package:portfolio_steve/shared/background.widget.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});
  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  List<Particle> particles = [];
  // On utilise un Offset simple sans setState
  Offset? mousePos;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      // On génère les particules une seule fois
      setState(() {
        particles = List.generate(
          80,
          (index) => Particle(
            x: Random().nextDouble() * size.width,
            y: Random().nextDouble() * size.height,
            dx: (Random().nextDouble() - 0.5) * 1.5,
            dy: (Random().nextDouble() - 0.5) * 1.5,
          ),
        );
      });
    });
  }

  void _updateParticles(Size size) {
    for (var p in particles) {
      p.x += p.dx;
      p.y += p.dy;

      if (p.x < 0 || p.x > size.width) p.dx *= -1;
      if (p.y < 0 || p.y > size.height) p.dy *= -1;

      if (mousePos != null) {
        // Optimisation : calcul de distance sans sqrt pour la performance si possible,
        // mais gardons ta logique pour la répulsion.
        double dist = sqrt(
          pow(p.x - mousePos!.dx, 2) + pow(p.y - mousePos!.dy, 2),
        );
        if (dist < 120) {
          p.x += (p.x < mousePos!.dx) ? -1 : 1;
          p.y += (p.y < mousePos!.dy) ? -1 : 1;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // On récupère la taille une seule fois
    final size = MediaQuery.of(context).size;

    return MouseRegion(
      // ⚠️ ON NE FAIT PLUS DE setState ICI
      onHover: (e) => mousePos = e.localPosition,
      onExit: (e) => mousePos = null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _updateParticles(size);
          return CustomPaint(
            // On s'assure que le CustomPaint ne bloque pas les interactions
            painter: ParticlePainter(particles, mousePos),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
