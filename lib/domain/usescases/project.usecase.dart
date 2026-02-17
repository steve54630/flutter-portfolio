import '../models/project.model.dart';
import '../models/skill.model.dart';
import '../entities/project.entity.dart';
import '../repositories/project.repository.dart';
import '../repositories/skill.repository.dart';

class GetProject {
  final IProjectRepository projectRepository;
  final ISkillRepository skillRepository;

  GetProject({required this.projectRepository, required this.skillRepository});

  Future<ProjectDetails> execute(String projectId) async {
    final results = await Future.wait([
      projectRepository.getProjectById(projectId),
      skillRepository.getSkills(),
    ]);

    final project = results[0] as Project;
    final skills = results[1] as List<Skill>;

    final fullSkills = project.skillIds.map((skillId) {
      return skills.firstWhere((skill) => skill.id == skillId);
    }).toList();

    return ProjectDetails(
      project: project,
      skills: fullSkills,
      mainTech: skills.firstWhere((skill) => skill.id == project.mainTech),
    );
  }
}
