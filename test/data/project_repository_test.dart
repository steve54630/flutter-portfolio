import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_steve/data/repositories/project.json.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsonProjectRepository Tests', () {
    late JsonProjectRepository repository;

    setUp(() {
      repository = JsonProjectRepository();

      // On crée un mock de contenu JSON
      final mockProjects = [
        {
          "id": "1",
          "title": "Projet Test",
          "description": "Une description",
          "images": ["img1.png"], // Ajouté
          "mainTech": "dart",
          "skillIds": ["skill1"], // Ajouté
          "strengths": ["Rapide"], // Ajouté
          "link": "https://github.com", // Ajouté
        },
      ];

      // On configure le Mock du BinaryMessenger pour intercepter TOUT appel d'asset
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            // On renvoie systématiquement nos données de test encodées
            final String encoded = json.encode(mockProjects);
            final Uint8List bytes = Uint8List.fromList(utf8.encode(encoded));
            return bytes.buffer.asByteData();
          });
    });

    test('doit charger et parser le fichier projects.json', () async {
      final projects = await repository.getProjects();
      expect(projects, isNotEmpty);
      expect(projects.first.title, equals("Projet Test"));
    });
  });
}
