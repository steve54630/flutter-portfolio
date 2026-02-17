import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_steve/domain/entities/experience.entity.dart';
import 'package:portfolio_steve/domain/models/experience.model.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/experience.repository.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';
import 'package:portfolio_steve/domain/usescases/experience.usecase.dart';

class MockExperienceRepository extends Mock implements IExperienceRepository {}

class MockSkillRepository extends Mock implements ISkillRepository {}

void main() {
  late GetExperience useCase;
  late MockExperienceRepository mockExpRepo;
  late MockSkillRepository mockSkillRepo;

  setUp(() {
    mockExpRepo = MockExperienceRepository();
    mockSkillRepo = MockSkillRepository();
    useCase = GetExperience(
      experienceRepository: mockExpRepo,
      skillRepository: mockSkillRepo,
    );
  });

  group('GetExperienceDetails UseCase Tests', () {
    const tId = "exp1";

    final tExperience = Experience(
      id: tId,
      company: "Apple",
      role: "iOS Developer",
      description: "Swift & SwiftUI",
      period: "2022-2023",
      skillIds: ["s1", "s2"],
    );

    final tSkills = [
      Skill(id: "s1", name: "Swift", categoryId: "lang"),
      Skill(id: "s2", name: "SwiftUI", categoryId: "fw"),
      Skill(id: "s3", name: "Git", categoryId: "tool"),
    ];

    test(
      'doit retourner ExperienceDetails avec les skills mappés pour un ID valide',
      () async {
        // Arrange
        when(
          () => mockExpRepo.getExperienceById(tId),
        ).thenAnswer((_) async => tExperience);
        when(() => mockSkillRepo.getSkills()).thenAnswer((_) async => tSkills);

        // Act
        final result = await useCase.execute(tId);

        // Assert
        expect(result, isA<ExperienceDetails>());
        expect(result.experience.company, "Apple");

        // Vérification du mapping des skills
        expect(result.skills.length, 2);
        expect(result.skills[0].id, "s1");
        expect(result.skills[0].name, "Swift");
        expect(result.skills[1].name, "SwiftUI");

        verify(() => mockExpRepo.getExperienceById(tId)).called(1);
        verify(() => mockSkillRepo.getSkills()).called(1);
      },
    );

    test('doit filtrer les skills inexistants dans le mapping', () async {
      // Arrange : l'expérience demande un skill ID "s99" qui n'existe pas dans la liste tSkills
      final tExpWithUnknownSkill = Experience(
        id: tId,
        company: "Apple",
        role: "Dev",
        description: "Desc",
        period: "2022",
        skillIds: ["s1", "s99"],
      );

      when(
        () => mockExpRepo.getExperienceById(tId),
      ).thenAnswer((_) async => tExpWithUnknownSkill);
      when(() => mockSkillRepo.getSkills()).thenAnswer((_) async => tSkills);

      // Act
      final result = await useCase.execute(tId);

      // Assert
      expect(result.skills.length, 1); // Seul "s1" (Swift) doit être présent
      expect(result.skills.first.name, "Swift");
    });

    test(
      'doit propager l\'exception quand le repository d\'expérience échoue',
      () async {
        // Arrange
        when(
          () => mockExpRepo.getExperienceById(any()),
        ).thenThrow(Exception("Erreur Repository"));

        // Act & Assert
        expect(() => useCase.execute(tId), throwsA(isA<Exception>()));
      },
    );
  });
}
