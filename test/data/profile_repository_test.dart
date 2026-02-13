import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_steve/data/repositories/profile.json.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsonProfileRepository Tests', () {
    late JsonProfileRepository repository;
    String? mockContent;
    const String profilePath = 'assets/data/profile.json';

    // Mock complet correspondant à ton JSON réel
    final defaultProfileData = {
      "identity": {
        "name": "Steve Retournay",
        "photo": "assets/images/profile.jpg",
        "location": "Nancy, France",
        "availability": "Mobile",
      },
      "contact": {
        "phone": "06 81 30 29 76",
        "email": "retournay.steve@yahoo.com",
        "linkedin": "https://linkedin.com/in/steve",
        "portfolio": "https://portfolio.vercel.app/",
      },
      "bio": {"title": "Profil", "content": "Ancien enseignant reconverti..."},
      "softSkills": ["Adaptabilité", "Pédagogie"],
      "interests": ["Jeux vidéo", "Cinéma"],
    };

    setUp(() {
      repository = JsonProfileRepository();
      mockContent = null;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            final String content =
                mockContent ?? json.encode(defaultProfileData);
            return Uint8List.fromList(utf8.encode(content)).buffer.asByteData();
          });
    });

    test(
      'getProfile doit mapper l’intégralité des données (Contact, Bio, Interests)',
      () async {
        final result = await repository.getProfile();

        // Identity
        expect(result.name, "Steve Retournay");

        // Contact (Sous-objet)
        expect(result.contact.phone, "06 81 30 29 76");
        expect(result.contact.linkedin, contains("linkedin"));

        // Bio
        expect(result.bioTitle, "Profil");
        expect(result.bioContent, contains("reconverti"));

        // Listes
        expect(result.softSkills, contains("Pédagogie"));
        expect(result.interests, contains("Jeux vidéo"));
      },
    );

    test(
      'getProfile doit lever DataSourceException si le JSON est corrompu',
      () async {
        // Reset du cache version non-dépréciée
        rootBundle.evict(profilePath);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage('flutter/assets', null, (data) {});

        mockContent = "INVALID_JSON";

        expect(
          () => repository.getProfile(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );

    test(
      'getProfile doit lever une erreur si la section contact est manquante',
      () async {
        rootBundle.evict(profilePath);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage('flutter/assets', null, (data) {});

        // JSON partiel qui fera crasher ton factory Contact.fromJson(json['contact'])
        mockContent = json.encode({
          "identity": {"name": "Steve"},
          "softSkills": [],
        });

        expect(
          () => repository.getProfile(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );
  });
}
