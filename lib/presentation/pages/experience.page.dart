import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/presentation/providers/experience.provider.dart';
import 'package:portfolio_steve/presentation/widgets/error.widget.dart';
import 'package:portfolio_steve/presentation/widgets/experiences.widget.dart';
import 'package:portfolio_steve/presentation/widgets/loading.widget.dart';
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
              color: Colors.blueAccent,
            ),
          ),
        ),

        // 2. Liste des Expériences
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Consumer<ExperienceProvider>(
            builder: (context, value, child) {
              if (value.isLoadingList) {
                return const LoadingWidget();
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
                  return ExperienceWidget(experienceDetails: experienceDetail);
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
