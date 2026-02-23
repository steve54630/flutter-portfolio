import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/domain/entities/project.entity.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';
import 'package:portfolio_steve/presentation/widgets/carousel.widget.dart';
import 'package:portfolio_steve/shared/urllauncher.dart';

class ProjectDetailDialog extends StatelessWidget {
  final ProjectDetails details;

  const ProjectDetailDialog({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final project = details.project;

    return Dialog(
      // 1. Fond correspondant à ton thème de surface
      backgroundColor: const Color(0xFF161616),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, project),

              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: GoogleFonts.aleo(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      project.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),

                    const SizedBox(height: 32),
                    _buildTechSection(context),

                    const Divider(height: 60, color: Colors.white10),
                    _buildActions(context, project),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Project project) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          // 1. Le Carousel (fond de la pile)
          Carousel(images: project.images),

          // 2. Le Gradient (ON MET POSITIONED EN PREMIER)
          Positioned.fill(
            child: IgnorePointer(
              // 👈 IgnorePointer est maintenant à l'intérieur
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Le bouton fermer
          Positioned(
            top: 16,
            right: 16,
            child: IconButton.filled(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "STACK TECHNIQUE",
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent, // Rappel de ta couleur seed
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: details.skills
              .map(
                (skill) => Chip(
                  label: Text(
                    skill.name,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, Project project) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: () => LauncherUtils.openUrl(project.link),
          icon: const Icon(Icons.code, size: 20),
          label: const Text("GITHUB"),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
            textStyle: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        if (project.demo != null)
          ElevatedButton.icon(
            onPressed: () => LauncherUtils.openUrl(project.demo!),
            icon: const Icon(Icons.launch, size: 20),
            label: const Text("VOIR LE PROJET"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
      ],
    );
  }
}
