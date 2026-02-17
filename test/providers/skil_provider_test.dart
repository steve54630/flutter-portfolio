import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';
import 'package:portfolio_steve/presentation/providers/skill.provider.dart';

class MockSkillRepository extends Mock implements ISkillRepository {}

void main() {
  late SkillProvider provider;
  late MockSkillRepository mockRepo;

  setUp(() {
    mockRepo = MockSkillRepository();
    provider = SkillProvider(repository: mockRepo);
  });

  final tSkill = Skill(id: "s1", name: "Flutter", categoryId: "fw");
  final tSkills = [tSkill, Skill(id: "s2", name: "Dart", categoryId: "lang")];

  group('SkillProvider - Solo Skill', () {
    test(
      'loadSkill doit charger un skill unique et mettre à jour l\'état',
      () async {
        // Arrange
        when(() => mockRepo.getSkillById("s1")).thenAnswer((_) async => tSkill);

        // Act
        final future = provider.loadSkill("s1");
        expect(provider.isLoading, true);

        await future;

        // Assert
        expect(provider.skill, tSkill);
        expect(provider.isLoading, false);
        expect(provider.error, null);
        verify(() => mockRepo.getSkillById("s1")).called(1);
      },
    );

    test(
      'loadSkill doit capturer l\'erreur si le skill n\'est pas trouvé',
      () async {
        // Arrange
        when(
          () => mockRepo.getSkillById(any()),
        ).thenThrow(Exception("Skill not found"));

        // Act
        await provider.loadSkill("unknown");

        // Assert
        expect(provider.isLoading, false);
        expect(provider.error, contains("Skill not found"));
        expect(provider.skill, null);
      },
    );
  });

  group('SkillProvider - All Skills', () {
    test('loadSkills doit charger la liste complète', () async {
      when(() => mockRepo.getSkills()).thenAnswer((_) async => tSkills);

      await provider.loadSkills();

      expect(provider.skills.length, 2);
      expect(provider.isLoading, false);
    });

    test('getSkillsByCategory doit filtrer la liste locale', () async {
      when(() => mockRepo.getSkills()).thenAnswer((_) async => tSkills);
      await provider.loadSkills();

      final filtered = provider.getSkillsByCategory("fw");

      expect(filtered.length, 1);
      expect(filtered.first.name, "Flutter");
    });
  });
}
