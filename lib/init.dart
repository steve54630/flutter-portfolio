import 'package:get_it/get_it.dart';
import 'package:portfolio_steve/data/repositories/experience.json.dart';
import 'package:portfolio_steve/data/repositories/profile.json.dart';
import 'package:portfolio_steve/data/repositories/project.json.dart';
import 'package:portfolio_steve/data/repositories/skill.json.dart';
import 'package:portfolio_steve/domain/repositories/experience.repository.dart';
import 'package:portfolio_steve/domain/repositories/profile.repository.dart';
import 'package:portfolio_steve/domain/repositories/project.repository.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';
import 'package:portfolio_steve/domain/usescases/experience.usecase.dart';
import 'package:portfolio_steve/domain/usescases/experiences.usecase.dart';
import 'package:portfolio_steve/domain/usescases/project.usecase.dart';
import 'package:portfolio_steve/domain/usescases/projects.usecase.dart';
import 'package:portfolio_steve/presentation/providers/experience.provider.dart';
import 'package:portfolio_steve/presentation/providers/project.provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<IProjectRepository>(() => JsonProjectRepository());
  sl.registerLazySingleton<ISkillRepository>(() => JsonSkillRepository());
  sl.registerLazySingleton<IExperienceRepository>(
    () => JsonExperienceRepository(),
  );
  sl.registerLazySingleton<IProfileRepository>(() => JsonProfileRepository());

  // Use Cases
  sl.registerLazySingleton(
    () => GetProject(projectRepository: sl(), skillRepository: sl()),
  );

  sl.registerLazySingleton(
    () => GetProjects(projectRepository: sl(), skillRepository: sl()),
  );

  sl.registerLazySingleton(
    () => GetExperience(experienceRepository: sl(), skillRepository: sl()),
  );

  sl.registerLazySingleton(
    () => GetExperiences(experienceRepository: sl(), skillRepository: sl()),
  );

  sl.registerFactory(
    () => ProjectProvider(getProjects: sl(), getProjectById: sl()),
  );

  sl.registerFactory(
    () => ExperienceProvider(getExperiences: sl(), getExperienceById: sl()),
  );
}
