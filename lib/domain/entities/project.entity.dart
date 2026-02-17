// lib/domain/models/project_details.dart
import '../models/project.model.dart';
import '../models/skill.model.dart';

class ProjectDetails {
  final Project project;
  final List<Skill> skills;
  final Skill mainTech;

  ProjectDetails({
    required this.project,
    required this.skills,
    required this.mainTech,
  });
}
