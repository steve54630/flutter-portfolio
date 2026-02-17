import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_steve/domain/entities/experience.entity.dart';
import 'package:portfolio_steve/domain/models/experience.model.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/experience.repository.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';
import 'package:portfolio_steve/domain/usescases/experiences.usecase.dart'; // Vérifie le chemin
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';

// Mocks des interfaces
class MockExperienceRepository extends Mock implements IExperienceRepository {}

class MockSkillRepository extends Mock implements ISkillRepository {}

void main() {
  late GetExperiences useCase;
  late MockExperienceRepository mockExpRepo;
  late MockSkillRepository mockSkillRepo;

  setUp(() {
    mockExpRepo = MockExperienceRepository();
    mockSkillRepo = MockSkillRepository();
    useCase = GetExperiences(
      experienceRepository: mockExpRepo,
      skillRepository: mockSkillRepo,
    );
  });

  group('GetExperiences UseCase - Tests Détaillés', () {
    // Données de test réutilisables
    final tExperience = Experience(
      id: "exp1",
      company: "Google",
      description: "Dev Flutter",
      period: "2024 - Présent",
      skillIds: ["s1", "s2"],
      role: 'Senior Dev', // Attend deux skills
    );

    final tSkills = [
      Skill(id: "s1", name: "Dart", categoryId: "lang"),
      Skill(id: "s2", name: "Flutter", categoryId: "fw"),
    ];

    test(
      'doit retourner une liste de ExperienceDetails avec les skills mappés',
      () async {
        // Arrange (GIVEN)
        when(
          () => mockExpRepo.getExperiences(),
        ).thenAnswer((_) async => [tExperience]);
        when(() => mockSkillRepo.getSkills()).thenAnswer((_) async => tSkills);

        // Act (WHEN)
        final result = await useCase.execute();

        // Assert (THEN)
        expect(result, isA<List<ExperienceDetails>>());
        expect(result.length, 1);

        final details = result.first;
        expect(details.experience.id, "exp1");

        // Vérification détaillée du mapping des skills
        expect(details.skills.length, 2);
        expect(details.skills[0].name, "Dart");
        expect(details.skills[1].name, "Flutter");

        // Vérifier que les dépôts ont été sollicités
        verify(() => mockExpRepo.getExperiences()).called(1);
        verify(() => mockSkillRepo.getSkills()).called(1);
      },
    );

    test(
      'doit filtrer les skills si un ID n\'existe pas dans le SkillRepository',
      () async {
        // Arrange
        // L'expérience demande "s1" et "inconnu", mais seul "s1" est fourni par le repo de skills
        final expWithUnknownSkill = Experience(
          id: "e2",
          company: "Test",
          role: "Dev",
          description: "Desc",
          period: "2023",
          skillIds: ["s1", "ID_INCONNU"],
        );

        when(
          () => mockExpRepo.getExperiences(),
        ).thenAnswer((_) async => [expWithUnknownSkill]);
        when(
          () => mockSkillRepo.getSkills(),
        ).thenAnswer((_) async => [tSkills[0]]); // Uniquement s1

        // Act
        final result = await useCase.execute();

        // Assert
        expect(
          result.first.skills.length,
          1,
        ); // "ID_INCONNU" a été supprimé par .whereType<Skill>()
        expect(result.first.skills.first.id, "s1");
      },
    );

    test(
      'doit lever une DataSourceException si le repository d\'expérience échoue',
      () async {
        // Arrange
        when(
          () => mockExpRepo.getExperiences(),
        ).thenThrow(Exception("Erreur de lecture JSON"));
        when(() => mockSkillRepo.getSkills()).thenAnswer((_) async => tSkills);

        // Act & Assert
        expect(() => useCase.execute(), throwsA(isA<DataSourceException>()));
      },
    );
  });
}
