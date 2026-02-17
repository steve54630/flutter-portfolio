import '../models/experience.model.dart';

abstract interface class IExperienceRepository {
  Future<List<Experience>> getExperiences();
  Future<Experience> getExperienceById(String id);
}
