import 'package:portfolio_steve/domain/entities/experience.entity.dart';
import 'package:portfolio_steve/domain/models/experience.model.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/experience.repository.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';

class GetExperience {
  final IExperienceRepository experienceRepository;
  final ISkillRepository skillRepository;

  GetExperience({
    required this.experienceRepository,
    required this.skillRepository,
  });

  Future<ExperienceDetails> execute(String id) async {
    // 1. On lance les deux appels en parallèle
    final results = await Future.wait([
      experienceRepository.getExperienceById(id),
      skillRepository.getSkills(),
    ]);

    final experience = results[0] as Experience;
    final allSkills = results[1] as List<Skill>;

    // 2. On indexe les skills pour un accès rapide
    final skillMap = {for (var s in allSkills) s.id: s};

    // 3. On construit l'entité de détail
    return ExperienceDetails(
      experience: experience,
      skills: experience.skillIds
          .map((skillId) => skillMap[skillId])
          .whereType<Skill>()
          .toList(),
    );
  }
}
