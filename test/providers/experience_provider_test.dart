import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_steve/domain/entities/experience.entity.dart';
import 'package:portfolio_steve/domain/models/experience.model.dart';
import 'package:portfolio_steve/domain/usescases/experience.usecase.dart';
import 'package:portfolio_steve/domain/usescases/experiences.usecase.dart';
import 'package:portfolio_steve/presentation/providers/experience.provider.dart';

class MockGetExperiences extends Mock implements GetExperiences {}

class MockGetExperience extends Mock implements GetExperience {}

void main() {
  late ExperienceProvider provider;
  late MockGetExperiences mockGetExperiences;
  late MockGetExperience mockGetExperienceById;

  setUp(() {
    mockGetExperiences = MockGetExperiences();
    mockGetExperienceById = MockGetExperience();
    provider = ExperienceProvider(
      getExperiences: mockGetExperiences,
      getExperienceById: mockGetExperienceById,
    );
  });

  // Donnée de test
  final tExpDetails = ExperienceDetails(
    experience: Experience(
      id: "e1",
      company: "Test",
      role: "Dev",
      description: "...",
      period: "2024",
      skillIds: [],
    ),
    skills: [],
  );

  group('ExperienceProvider - All Experiences', () {
    test('doit mettre à jour les expériences et gérer le loading', () async {
      // Arrange
      when(
        () => mockGetExperiences.execute(),
      ).thenAnswer((_) async => [tExpDetails]);

      // Act & Assert (Vérification de l'état initial)
      expect(provider.isLoadingList, false);
      expect(provider.experiences, []);

      // On lance le chargement
      final future = provider.loadAllExperiences();

      // Vérification pendant le chargement
      expect(provider.isLoadingList, true);

      await future;

      // Vérification après chargement
      expect(provider.experiences, [tExpDetails]);
      expect(provider.isLoadingList, false);
      verify(() => mockGetExperiences.execute()).called(1);
    });

    test('doit repasser isLoading à false même en cas d\'erreur', () async {
      // Arrange
      when(() => mockGetExperiences.execute()).thenThrow(Exception("Erreur"));

      // Act
      await provider.loadAllExperiences();

      // Assert
      expect(provider.isLoadingList, false);
      expect(provider.experiences, []); // Reste vide
    });
  });

  group('ExperienceProvider - Single Experience', () {
    test(
      'doit charger une expérience spécifique et reset le précédent selectedExperience',
      () async {
        // Arrange
        const tId = "e1";
        when(
          () => mockGetExperienceById.execute(tId),
        ).thenAnswer((_) async => tExpDetails);

        // Act
        final future = provider.loadSingleExperience(tId);

        expect(provider.isLoadingDetail, true);
        expect(
          provider.selectedExperience,
          null,
        ); // Vérifie le reset au début du call

        await future;

        // Assert
        expect(provider.selectedExperience, tExpDetails);
        expect(provider.isLoadingDetail, false);
        verify(() => mockGetExperienceById.execute(tId)).called(1);
      },
    );
  });
}
