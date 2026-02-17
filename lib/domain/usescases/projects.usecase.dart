import 'package:portfolio_steve/domain/entities/project.entity.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/project.repository.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';

class GetProjects {
  final IProjectRepository projectRepository;
  final ISkillRepository skillRepository;

  GetProjects({required this.projectRepository, required this.skillRepository});

  Future<List<ProjectDetails>> execute() async {
    final results = await Future.wait([
      projectRepository.getProjects(), // Récupère TOUS les projets
      skillRepository.getSkills(),
    ]);

    final projects = results[0] as List<Project>;
    final allSkills = results[1] as List<Skill>;

    // Indexation pour passer d'une recherche O(n) à O(1)
    final skillMap = {for (var s in allSkills) s.id: s};

    return projects.map((project) {
      return ProjectDetails(
        project: project,
        skills: project.skillIds
            .map((id) => skillMap[id])
            .whereType<Skill>()
            .toList(),
        mainTech: skillMap[project.mainTech]!,
      );
    }).toList();
  }
}
