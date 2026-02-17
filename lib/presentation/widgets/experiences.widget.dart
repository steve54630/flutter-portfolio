import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/domain/entities/experience.entity.dart';
import 'package:portfolio_steve/domain/models/experience.model.dart';

class ExperienceWidget extends StatelessWidget {
  final ExperienceDetails experienceDetails;
  final Experience experience;

  ExperienceWidget({super.key, required this.experienceDetails})
    : experience = experienceDetails.experience;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Text(experience.role, style: Theme.of(context).textTheme.titleLarge),
          Text(
            experience.company,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            "Période : ${experience.period}",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(height: 16),
          Text(
            experience.description,
            style: GoogleFonts.aleo(
              textStyle: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: experienceDetails.skills.map((skill) {
              return Chip(
                label: Text(
                  skill.name,
                  style: GoogleFonts.jetBrainsMono(fontSize: 11),
                ),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.2),
                side: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
