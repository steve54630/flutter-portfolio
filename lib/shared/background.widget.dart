import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio_steve/domain/entities/particules.entity.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? mousePos;

  ParticlePainter(this.particles, this.mousePos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
          .withValues(alpha: 0.6) // Plus d'opacité
      ..strokeWidth =
          2.0 // Particules plus grosses
      ..style = PaintingStyle.fill;

    final linePaint = Paint()..style = PaintingStyle.stroke;

    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];

      // Dessiner la particule (un peu plus grande)
      canvas.drawCircle(Offset(p.x, p.y), 2.5, paint);

      // Dessiner les connexions
      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final dist = sqrt(pow(p.x - p2.x, 2) + pow(p.y - p2.y, 2));

        if (dist < 150) {
          // Rayon de connexion augmenté
          // Calcul d'opacité inversement proportionnel à la distance
          // Plus c'est proche, plus c'est blanc/lumineux
          double opacity = (1.0 - (dist / 150)).clamp(0.0, 1.0);

          linePaint
            ..color = Colors.white.withValues(alpha: opacity * 0.3)
            ..strokeWidth = opacity * 1.5; // Épaisseur dynamique

          canvas.drawLine(Offset(p.x, p.y), Offset(p2.x, p2.y), linePaint);
        }
      }

      // Optionnel : Lien avec la souris
      if (mousePos != null) {
        final mDist = sqrt(
          pow(p.x - mousePos!.dx, 2) + pow(p.y - mousePos!.dy, 2),
        );
        if (mDist < 180) {
          double mOpacity = (1.0 - (mDist / 180)).clamp(0.0, 1.0);
          linePaint.color = Colors.redAccent.withValues(alpha: mOpacity * 0.5);
          canvas.drawLine(Offset(p.x, p.y), mousePos!, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
