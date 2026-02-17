import 'package:flutter/material.dart';
import 'package:portfolio_steve/presentation/pages/experience.page.dart';
import 'package:portfolio_steve/presentation/pages/profile.page.dart';
import 'package:portfolio_steve/presentation/pages/project.page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // On utilise Consumer pour reconstruire uniquement cette partie quand le profil change
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Page de profil (Header/Bio)
            ProfilePage(),

            // 2. Page d'expériences
            ExperiencePage(),

            // 3. Page de projets
            ProjectPage(),

            // Un petit espace en bas de page
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
