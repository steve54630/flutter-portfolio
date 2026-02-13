import 'package:flutter/material.dart';
import 'package:portfolio_steve/presentation/widgets/Inforow.widget.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_steve/presentation/providers/profile.provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // On utilise Consumer pour reconstruire uniquement cette partie quand le profil change
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          // 1. État de chargement
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. État d'erreur
          if (profileProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text("Erreur : ${profileProvider.error}"),
                  ElevatedButton(
                    onPressed: () => profileProvider.loadProfile(),
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            );
          }

          // 3. État Succès (Données prêtes)
          final profile = profileProvider.profile;
          if (profile == null) {
            return const Center(child: Text("Aucune donnée"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Text(
                  "Bonjour, je suis",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  profile.bioContent,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Divider(height: 40),
                InfoRow(icon: Icons.location_on, text: profile.location),
                InfoRow(icon: Icons.email, text: profile.contact.email),
                InfoRow(icon: Icons.link, text: profile.contact.linkedin),
                SizedBox(height: 32),
                Text(
                  "Mes Soft Skills",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: profile.softSkills
                      .map((skill) => Chip(label: Text(skill)))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
