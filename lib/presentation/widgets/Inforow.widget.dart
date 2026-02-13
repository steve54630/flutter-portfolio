import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  // Le constructeur "const" est le secret de la performance en Flutter
  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          // Flexible permet d'éviter l'overflow si le texte est trop long sur mobile
          Flexible(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
