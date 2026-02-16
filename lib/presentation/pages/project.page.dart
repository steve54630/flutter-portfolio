import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/presentation/widgets/error.widget.dart';
import 'package:portfolio_steve/presentation/widgets/loading.widget.dart';
import 'package:provider/provider.dart'; // Import manquant
import 'package:portfolio_steve/presentation/providers/project.provider.dart'; // Vérifie ton chemin
import 'package:portfolio_steve/presentation/widgets/projectcard.widget.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Section Titre "Mes Projets"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Text(
            "Mes Projets",
            style: GoogleFonts.aleo(
              textStyle: Theme.of(context).textTheme.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 2. Section Grille de Projets
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Consumer<ProjectProvider>(
            builder: (context, projectProvider, child) {
              if (projectProvider.isLoadingList) {
                return LoadingWidget();
              }

              if (projectProvider.errorMessage != null) {
                return ErrorMessage(
                  errorMessage: projectProvider.errorMessage!,
                  onRetry: projectProvider.loadAllProjects(),
                );
              }

              final projects = projectProvider.projects;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 450,
                  mainAxisExtent: 530,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return ProjectCard(projectDetails: projects[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
