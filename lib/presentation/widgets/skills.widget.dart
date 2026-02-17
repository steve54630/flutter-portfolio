import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';

class SkillsRow extends StatelessWidget {
  final List<Skill> skills;

  const SkillsRow({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        return Chip(
          label: Text(
            skill.name,
            style: GoogleFonts.jetBrainsMono(fontSize: 11),
          ),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.2),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ),
        );
      }).toList(),
    );
  }
}
