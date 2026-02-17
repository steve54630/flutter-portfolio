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
        clipBehavior: Clip.antiAlias,
        child: InkWell(
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
                child: Image.asset(
                  project.images[0],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.code, color: Colors.white, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          "Image introuvable",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: GoogleFonts.aleo(
                        textStyle: Theme.of(context).textTheme.titleLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
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
