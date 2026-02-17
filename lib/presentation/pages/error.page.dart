import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  final Exception? error;
  const ErrorPage({super.key, this.error});

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text("Erreur : ${error.toString()}"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text("Retour à l'accueil"),
            ),
          ],
        ),
      ),
    );
  }
}
