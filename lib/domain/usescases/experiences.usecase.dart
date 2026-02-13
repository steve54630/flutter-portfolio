import 'package:portfolio_steve/domain/entities/experience.entity.dart';
import 'package:portfolio_steve/domain/models/experience.model.dart';

import '../repositories/experience.repository.dart';
import '../repositories/skill.repository.dart';
import '../models/skill.model.dart';
import '../exceptions/datasource.exception.dart';

class GetExperiences {
  final IExperienceRepository experienceRepository;
  final ISkillRepository skillRepository;

  GetExperiences({
    required this.experienceRepository,
    required this.skillRepository,
  });

  Future<List<ExperienceDetails>> execute() async {
    try {
      final results = await Future.wait([
        experienceRepository.getExperiences(),
        skillRepository.getSkills(),
      ]);

      final experiences = results[0] as List<Experience>;
      final allSkills = results[1] as List<Skill>;

      final skillMap = {for (var s in allSkills) s.id: s};

      return experiences.map((exp) {
        return ExperienceDetails(
          experience: exp,
          skills: exp.skillIds
              .map((id) => skillMap[id])
              .whereType<Skill>()
              .toList(),
        );
      }).toList();
    } on DataSourceException {
      rethrow;
    } catch (e) {
      throw DataSourceException("GetExperiencesDetails Error: $e");
    }
  }
}
