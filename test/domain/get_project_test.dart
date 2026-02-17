import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_steve/domain/entities/project.entity.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/project.repository.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';
import 'package:portfolio_steve/domain/usescases/project.usecase.dart';

class MockProjectRepository extends Mock implements IProjectRepository {}

class MockSkillRepository extends Mock implements ISkillRepository {}

void main() {
  late GetProject useCase;
  late MockProjectRepository mockProjectRepo;
  late MockSkillRepository mockSkillRepo;

  setUp(() {
    mockProjectRepo = MockProjectRepository();
    mockSkillRepo = MockSkillRepository();
    useCase = GetProject(
      projectRepository: mockProjectRepo,
      skillRepository: mockSkillRepo,
    );
  });

  group('GetProject (Solo) UseCase Tests', () {
    const tId = "p1";

    final tProject = Project(
      id: tId,
      title: "Solo Project",
      description: "Desc",
      images: [],
      mainTech: "s1",
      skillIds: ["s1", "s2"],
      strengths: [],
      link: "",
    );

    final tSkills = [
      Skill(id: "s1", name: "Dart", categoryId: "lang"),
      Skill(id: "s2", name: "Flutter", categoryId: "fw"),
    ];

    test('doit retourner ProjectDetails enrichi pour un ID donné', () async {
      // Arrange
      when(
        () => mockProjectRepo.getProjectById(tId),
      ).thenAnswer((_) async => tProject);
      when(() => mockSkillRepo.getSkills()).thenAnswer((_) async => tSkills);

      // Act
      final result = await useCase.execute(tId);

      // Assert
      expect(result, isA<ProjectDetails>());
      expect(result.project.id, tId);
      expect(result.skills.length, 2);
      expect(result.skills.first.name, "Dart");
      expect(result.mainTech.name, "Dart");

      verify(() => mockProjectRepo.getProjectById(tId)).called(1);
      verify(() => mockSkillRepo.getSkills()).called(1);
    });

    test('doit propager l\'exception si le projet n\'est pas trouvé', () async {
      // Arrange
      when(
        () => mockProjectRepo.getProjectById(any()),
      ).thenThrow(Exception("Not Found"));

      // Act & Assert
      expect(() => useCase.execute("wrong_id"), throwsA(isA<Exception>()));
    });
  });
}
