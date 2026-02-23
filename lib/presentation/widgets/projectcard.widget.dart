import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/domain/entities/project.entity.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';
import 'package:portfolio_steve/presentation/widgets/hover.widget.dart';
import 'package:portfolio_steve/presentation/widgets/project.dialog.widget.dart';
import 'package:portfolio_steve/presentation/widgets/skills.widget.dart';

class ProjectCard extends StatelessWidget {
  final ProjectDetails projectDetails;
  final Project project;

  ProjectCard({super.key, required this.projectDetails})
    : project = projectDetails.project;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Card(
        // 1. Fond semi-transparent pour laisser deviner les particules derrière
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.8),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          // 2. Bordure subtile pour détacher la carte du fond noir
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: InkWell(
          // Couleur du splash lors du clic (en accord avec ton seedColor)
          splashColor: Colors.redAccent.withValues(alpha: 0.1),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  ProjectDetailDialog(details: projectDetails),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Image.asset(
                      project.images[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF252525),
                        width: double.infinity,
                        child: const Icon(
                          Icons.code,
                          color: Colors.redAccent,
                          size: 48,
                        ),
                      ),
                    ),
                    // 3. Overlay dégradé pour que le titre de l'image ne jure pas
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF1E1E1E).withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: GoogleFonts.aleo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Blanc pur pour le titre
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      project.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: 0.7,
                        ), // Gris clair pour le corps
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 4. Tes SkillsRow ici (assure-toi que les puces sont colorées)
                    SkillsRow(skills: projectDetails.skills),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
