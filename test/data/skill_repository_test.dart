import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_steve/data/repositories/skill.json.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsonSkillRepository Tests', () {
    late JsonSkillRepository repository;
    String? mockContent;
    const String skillPath = 'assets/data/skills.json';

    final defaultSkillsData = [
      {"id": "s1", "name": "Dart", "categoryId": "lang"},
      {"id": "s2", "name": "Flutter", "categoryId": "framework"},
      {"id": "s3", "name": "Firebase", "categoryId": "backend"},
    ];

    setUp(() {
      repository = JsonSkillRepository();
      mockContent = null;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            final String content =
                mockContent ?? json.encode(defaultSkillsData);
            return Uint8List.fromList(utf8.encode(content)).buffer.asByteData();
          });
    });

    test(
      'getSkills doit retourner la liste complète des compétences',
      () async {
        final result = await repository.getSkills();

        expect(result, isA<List<Skill>>());
        expect(result.length, 3);
        expect(result.first.name, "Dart");
      },
    );

    test(
      'getSkillById doit retourner le bon skill pour un ID existant',
      () async {
        final result = await repository.getSkillById("s2");

        expect(result.id, "s2");
        expect(result.name, "Flutter");
        expect(result.categoryId, "framework");
      },
    );

    test(
      'getSkillById doit lever NotFoundException pour un ID inexistant',
      () async {
        expect(
          () => repository.getSkillById("unknown_id"),
          throwsA(isA<NotFoundException>()),
        );
      },
    );

    test(
      'getSkills doit lever DataSourceException si le JSON est corrompu',
      () async {
        rootBundle.evict(skillPath);
        mockContent = "NOT_A_JSON_LIST";

        expect(
          () => repository.getSkills(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );
  });
}
