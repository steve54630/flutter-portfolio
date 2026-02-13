import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_steve/domain/models/contact.model.dart';
import 'package:portfolio_steve/domain/models/profile.model.dart';
import 'package:portfolio_steve/domain/repositories/profile.repository.dart';
import 'package:portfolio_steve/presentation/providers/profile.provider.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late ProfileProvider provider;
  late MockProfileRepository mockRepo;

  setUp(() {
    mockRepo = MockProfileRepository();
    provider = ProfileProvider(repository: mockRepo);
  });

  final tProfile = Profile(
    name: "Steve",
    photo: "photo.jpg",
    location: "Nancy",
    availability: "Dispo",
    contact: Contact(
      phone: "0600000000",
      email: "steve@test.com",
      linkedin: "li/steve",
      portfolio: "port.com",
    ),
    bioTitle: "Titre",
    bioContent: "Contenu",
    softSkills: ["Skill"],
    interests: ["Interest"],
  );

  group('ProfileProvider Tests', () {
    test(
      'doit charger le profil avec succès et mettre à jour l’état',
      () async {
        // Arrange
        when(() => mockRepo.getProfile()).thenAnswer((_) async => tProfile);

        // Act
        final future = provider.loadProfile();
        expect(provider.isLoading, true);

        await future;

        // Assert
        expect(provider.profile, tProfile);
        expect(provider.profile?.contact.phone, "0600000000");
        expect(provider.isLoading, false);
        expect(provider.error, null);
      },
    );

    test('doit capturer l’erreur en cas d’échec du repository', () async {
      // Arrange
      when(
        () => mockRepo.getProfile(),
      ).thenThrow(Exception("Erreur de chargement"));

      // Act
      await provider.loadProfile();

      // Assert
      expect(provider.isLoading, false);
      expect(provider.error, contains("Erreur de chargement"));
      expect(provider.profile, null);
    });
  });
}
