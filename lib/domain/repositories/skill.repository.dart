import '../models/skill.model.dart';

abstract interface class ISkillRepository {
  Future<List<Skill>> getSkills();
  Future<Skill> getSkillById(String id);
}
