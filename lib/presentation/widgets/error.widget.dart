import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String errorMessage;
  final dynamic onRetry; // Utilisation du type standard Flutter

  const ErrorMessage({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            "Erreur : $errorMessage",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => onRetry(),
            icon: const Icon(Icons.refresh),
            label: const Text("Réessayer"),
          ),
        ],
      ),
    );
  }
}
