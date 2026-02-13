import 'package:flutter/material.dart';
import 'package:portfolio_steve/app.dart';
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
import 'package:portfolio_steve/init.dart';
import 'package:portfolio_steve/presentation/providers/experience.provider.dart';
import 'package:portfolio_steve/presentation/providers/profile.provider.dart';
import 'package:portfolio_steve/presentation/providers/project.provider.dart';
import 'package:portfolio_steve/presentation/providers/skill.provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // Indispensable pour l'accès aux assets avant runApp
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiProvider(
      providers: [
        // --- REPOSITORIES (Data) ---
        Provider<IProjectRepository>(create: (_) => JsonProjectRepository()),
        Provider<IExperienceRepository>(
          create: (_) => JsonExperienceRepository(),
        ),
        Provider<ISkillRepository>(create: (_) => JsonSkillRepository()),
        Provider<IProfileRepository>(create: (_) => JsonProfileRepository()),

        // --- PROVIDERS (Logic) ---
        ChangeNotifierProvider(
          create: (context) =>
              ProfileProvider(repository: context.read<IProfileRepository>())
                ..loadProfile(), // On lance le chargement immédiatement
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SkillProvider(repository: context.read<ISkillRepository>())
                ..loadSkills(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProjectProvider(
            getProjects: GetProjects(
              projectRepository: context.read<IProjectRepository>(),
              skillRepository: context.read<ISkillRepository>(),
            ),
            getProjectById: GetProject(
              projectRepository: context.read<IProjectRepository>(),
              skillRepository: context.read<ISkillRepository>(),
            ),
          )..loadAllProjects(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExperienceProvider(
            getExperiences: GetExperiences(
              experienceRepository: context.read<IExperienceRepository>(),
              skillRepository: context.read<ISkillRepository>(),
            ),
            getExperienceById: GetExperience(
              experienceRepository: context.read<IExperienceRepository>(),
              skillRepository: context.read<ISkillRepository>(),
            ),
          )..loadAllExperiences(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
