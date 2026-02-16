import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/domain/entities/project.entity.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';
import 'package:portfolio_steve/domain/shared/urllauncher.dart';
import 'package:portfolio_steve/presentation/widgets/carousel.widget.dart';

class ProjectDetailDialog extends StatelessWidget {
  final ProjectDetails details;

  const ProjectDetailDialog({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final project = details.project;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER IMAGE ---
              _buildHeader(context, project),

              // --- CONTENT ---
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: GoogleFonts.aleo(
                        textStyle: Theme.of(context).textTheme.displaySmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      project.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(height: 1.6),
                    ),

                    const SizedBox(height: 32),
                    _buildTechSection(context),

                    const Divider(height: 60),
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
          Carousel(images: project.images),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton.filled(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
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
          "Stack Technique",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: details.skills
              .map(
                (skill) => Chip(
                  label: Text(skill.name),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
        OutlinedButton.icon(
          onPressed: () {
            LauncherUtils.openUrl(project.link);
          },
          icon: const Icon(Icons.code),
          label: const Text("Code Source"),
        ),
        const SizedBox(width: 16),
        if (project.demo != null)
          ElevatedButton.icon(
            onPressed: () {
              project.demo != null
                  ? LauncherUtils.openUrl(project.demo!)
                  : null;
            },
            icon: const Icon(Icons.launch),
            label: const Text("Voir le projet"),
          ),
      ],
    );
  }
}
