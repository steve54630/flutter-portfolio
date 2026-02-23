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
    return SizedBox(
      width: double.infinity, // Prend toute la largeur disponible
      child: Card(
        margin: const EdgeInsets.only(bottom: 20), // Espace entre les cartes
        color: const Color(
          0xFF1A1A1A,
        ), // Fond sombre légèrement différent du fond de page
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ), // Bordure subtile
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding interne crucial
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligne tout à gauche
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      experience.role,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Texte clair
                      ),
                    ),
                  ),
                  Text(
                    experience.period,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.redAccent, // Rappel de ton seedColor
                    ),
                  ),
                ],
              ),
              Text(
                experience.company,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      Colors.blueAccent, // Couleur distincte pour l'entreprise
                ),
              ),
              const SizedBox(height: 16),
              Text(
                experience.description,
                style: GoogleFonts.aleo(
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70, // Gris clair pour la description
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Tags / Skills
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: experienceDetails.skills.map((skill) {
                  return Chip(
                    label: Text(
                      skill.name,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
