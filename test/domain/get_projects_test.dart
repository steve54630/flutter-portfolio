import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_steve/domain/entities/project.entity.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/project.repository.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';
import 'package:portfolio_steve/domain/usescases/projects.usecase.dart';

// --- MOCKS ---
class MockProjectRepository extends Mock implements IProjectRepository {}

class MockSkillRepository extends Mock implements ISkillRepository {}

void main() {
  late GetProjects useCase;
  late MockProjectRepository mockProjectRepo;
  late MockSkillRepository mockSkillRepo;

  setUp(() {
    mockProjectRepo = MockProjectRepository();
    mockSkillRepo = MockSkillRepository();
    useCase = GetProjects(
      projectRepository: mockProjectRepo,
      skillRepository: mockSkillRepo,
    );
  });

  test(
    'doit retourner une liste de ProjectDetails enrichie de ses Skills',
    () async {
      // 1. GIVEN : On définit ce que les mocks renvoient
      final tProject = Project(
        id: "p1",
        title: "Portfolio",
        description: "Desc",
        images: [],
        mainTech: "s1",
        skillIds: ["s1", "s2"], // Le projet utilise s1 et s2
        strengths: [],
        link: "",
      );

      final tSkills = [
        Skill(id: "s1", name: "Dart", categoryId: 'Languages'),
        Skill(id: "s2", name: "Flutter", categoryId: 'Framework'),
      ];

      when(
        () => mockProjectRepo.getProjects(),
      ).thenAnswer((_) async => [tProject]);
      when(() => mockSkillRepo.getSkills()).thenAnswer((_) async => tSkills);

      // 2. WHEN : On exécute le Use Case
      final result = await useCase.execute();

      // 3. THEN : On vérifie la logique de fusion
      expect(result, isA<List<ProjectDetails>>());
      expect(result.length, 1);

      final details = result.first;
      expect(details.project.id, "p1");

      // Vérification cruciale : les IDs ont-ils été transformés en objets Skill ?
      expect(details.skills.length, 2);
      expect(details.skills[0].name, "Dart");
      expect(details.skills[1].name, "Flutter");
      expect(details.mainTech.name, "Dart");

      // On vérifie que les repos ont bien été appelés une fois
      verify(() => mockProjectRepo.getProjects()).called(1);
      verify(() => mockSkillRepo.getSkills()).called(1);
    },
  );
}
