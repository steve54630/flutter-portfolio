import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/presentation/providers/profile.provider.dart';
import 'package:portfolio_steve/presentation/widgets/Inforow.widget.dart';
import 'package:portfolio_steve/presentation/widgets/error.widget.dart';
import 'package:portfolio_steve/presentation/widgets/loading.widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        // 1. État de chargement
        if (profileProvider.isLoading) {
          return LoadingWidget();
        }

        // 2. État d'erreur
        if (profileProvider.error != null) {
          return ErrorMessage(
            errorMessage: profileProvider.error!,
            onRetry: profileProvider.loadProfile(),
          );
        }

        // 3. État Succès (Données prêtes)
        final profile = profileProvider.profile;
        if (profile == null) {
          return const Center(child: Text("Aucune donnée"));
        }

        // DANS ProfilePage
        return Column(
          // Exit le SingleChildScrollView ici
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            // Enveloppe tes textes dans le même padding que tes titres de projets (40)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bonjour, je suis",
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    profile.name,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.bioContent,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Divider(height: 40),
                  InfoRow(icon: Icons.location_on, text: profile.location),
                  InfoRow(icon: Icons.email, text: profile.contact.email),
                  InfoRow(icon: Icons.link, text: profile.contact.linkedin),
                ],
              ),
            ),

            // Titre Soft Skills (Déjà en padding 40, il sera donc aligné avec "Mes Projets")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Text(
                "Mes Soft Skills",
                style: GoogleFonts.aleo(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Wrap(
                spacing: 8,
                children: profile.softSkills
                    .map((skill) => Chip(label: Text(skill)))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
