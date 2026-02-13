import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_steve/data/repositories/experience.json.dart';
import 'package:portfolio_steve/domain/models/experience.model.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsonExperienceRepository Tests', () {
    late JsonExperienceRepository repository;
    String? mockContent;

    final defaultData = [
      {
        "id": "exp1",
        "company": "Tech Corp",
        "role": "Developer",
        "description": "Flutter dev",
        "period": "2023-2024",
        "skillIds": ["s1"],
      },
      {
        "id": "exp2",
        "company": "Design Studio",
        "role": "UI Designer",
        "description": "Figma",
        "period": "2022",
        "skillIds": [],
      },
    ];

    setUp(() {
      repository = JsonExperienceRepository();
      mockContent = null;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            final String content = mockContent ?? json.encode(defaultData);
            return Uint8List.fromList(utf8.encode(content)).buffer.asByteData();
          });
    });

    test(
      'getExperiences doit retourner une liste d\'objets Experience',
      () async {
        final result = await repository.getExperiences();
        expect(result, isA<List<Experience>>());
        expect(result.length, 2);
        expect(result.first.company, "Tech Corp");
      },
    );

    test(
      'getExperienceById doit retourner la bonne expérience si l\'ID existe',
      () async {
        final result = await repository.getExperienceById("exp2");
        expect(result.id, "exp2");
        expect(result.company, "Design Studio");
      },
    );

    test(
      'getExperienceById doit lever NotFoundException si l\'ID n\'existe pas',
      () async {
        expect(
          () => repository.getExperienceById("non_existent_id"),
          throwsA(isA<NotFoundException>()),
        );
      },
    );

    test(
      'getExperiences doit lever DataSourceException si le JSON est malformé',
      () async {
        // 1. On vide le cache pour forcer le bundle à lire notre mock corrompu
        // Pour vider le cache du canal assets proprement
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage('flutter/assets', null, (ByteData? data) {});

        // Et pour le handler lui-même, assure-toi d'utiliser :
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (ByteData? message) async {
              return null;
            });
        // Alternative radicale : vider le cache spécifique
        rootBundle.evict('assets/data/experiences.json');

        // 2. On redéfinit le handler pour renvoyer de la bouillie
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (ByteData? message) async {
              return Uint8List.fromList(
                utf8.encode("INVALID_JSON"),
              ).buffer.asByteData();
            });

        // 3. Act & Assert
        expect(
          () => repository.getExperiences(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );
  });
}
