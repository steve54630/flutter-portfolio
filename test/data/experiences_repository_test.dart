import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_steve/data/repositories/experience.json.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsonExperienceRepository Coverage Boost', () {
    late JsonExperienceRepository repository;
    const String experiencePath = 'data/experiences.json';

    setUp(() {
      repository = JsonExperienceRepository();
    });

    // Helper pour mocker le binaire messenger
    void mockRawAsset(String? content) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            if (content == null)
              return null; // Simule un asset inexistant ou inaccessible
            return Uint8List.fromList(utf8.encode(content)).buffer.asByteData();
          });
    }

    void mockJsonAsset(dynamic data) => mockRawAsset(json.encode(data));

    // Test de succès initial
    test('getExperiences doit charger les données avec succès', () async {
      rootBundle.evict(experiencePath);
      mockJsonAsset([
        {
          "id": "1",
          "role": "Dev",
          "company": "Test",
          "period": "2025",
          "description": "Desc",
          "skillIds": ["windev"],
        },
      ]);

      final experiences = await repository.getExperiences();
      expect(experiences, isNotEmpty);
      expect(experiences.first.id, "1");
    });

    // Couverture des blocs CATCH (Lignes 17 à 22 du Repository)
    test(
      'getExperiences doit lever DataSourceException si l\'asset est introuvable (FlutterError)',
      () async {
        rootBundle.evict(experiencePath);
        mockRawAsset(null); // Force le retour null pour déclencher FlutterError

        expect(
          () => repository.getExperiences(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );

    test(
      'getExperiences doit lever DataSourceException sur une erreur inattendue (catch total)',
      () async {
        // On force une exception brute pour passer dans le bloc catch(e) final
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler(
              'flutter/assets',
              (message) => throw Exception("Unexpected Crash"),
            );

        expect(
          () => repository.getExperiences(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );

    // Couverture de getExperienceById et de la ligne 33 (NotFoundException)
    test(
      'getExperienceById doit retourner l\'expérience si l\'ID existe',
      () async {
        rootBundle.evict(experiencePath);
        mockJsonAsset([
          {
            "id": "exp1",
            "role": "Dev",
            "company": "A",
            "period": "B",
            "description": "C",
            "skillIds": [],
          },
        ]);

        final result = await repository.getExperienceById("exp1");
        expect(result.id, "exp1");
      },
    );

    test(
      'getExperienceById doit lever NotFoundException si l\'ID est absent (Ligne 33)',
      () async {
        rootBundle.evict(experiencePath);
        mockJsonAsset([]); // On simule une liste vide pour forcer le NotFound

        expect(
          () => repository.getExperienceById("unknown_id"),
          throwsA(isA<NotFoundException>()),
        );
      },
    );
  });
}
