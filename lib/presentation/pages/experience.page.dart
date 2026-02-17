import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/presentation/providers/experience.provider.dart';
import 'package:portfolio_steve/presentation/widgets/error.widget.dart';
import 'package:portfolio_steve/presentation/widgets/loading.widget.dart';
import 'package:portfolio_steve/presentation/widgets/skills.widget.dart';
import 'package:provider/provider.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Titre de Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Text(
            "Mes Expériences",
            style: GoogleFonts.aleo(
              textStyle: Theme.of(context).textTheme.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 2. Liste des Expériences
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Consumer<ExperienceProvider>(
            builder: (context, value, child) {
              if (value.isLoadingList) {
                return LoadingWidget();
              }

              if (value.errorMessage != null) {
                return ErrorMessage(
                  errorMessage: value.errorMessage!,
                  onRetry: value.getExperiences,
                );
              }

              final experiences = value.experiences;

              return Column(
                children: experiences.map((experienceDetail) {
                  final experience = experienceDetail.experience;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icone ou Logo fictif à gauche
                            CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              child: Icon(
                                Icons.work_outline,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Détails de l'expérience
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    experience.role,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    experience.company,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    experience.description,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SkillsRow(skills: experienceDetail.skills),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
