import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_steve/data/repositories/skill.json.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';

class FakeSkillBundle extends Fake implements AssetBundle {
  String? content;
  bool throwError = false;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (throwError) throw FlutterError("Error loading asset");
    return content ?? '[]';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsonSkillRepository Coverage Tests', () {
    late JsonSkillRepository repository;
    late FakeSkillBundle fakeBundle;

    final validSkillsJson = json.encode([
      {"id": "s1", "name": "Dart", "categoryId": "lang"},
      {"id": "s2", "name": "Flutter", "categoryId": "framework"},
    ]);

    setUp(() {
      fakeBundle = FakeSkillBundle();
      // Assure-toi que ton JsonSkillRepository accepte (bundle: fakeBundle)
      repository = JsonSkillRepository(bundle: fakeBundle);
    });

    test('getSkills doit retourner la liste complète', () async {
      fakeBundle.content = validSkillsJson;
      final result = await repository.getSkills();
      expect(result.length, 2);
      expect(result.first.name, "Dart");
    });

    test('getSkillById doit retourner le skill si l\'ID existe', () async {
      fakeBundle.content = validSkillsJson;
      final result = await repository.getSkillById("s2");
      expect(result.name, "Flutter");
    });

    test('getSkillById doit lever NotFoundException si ID inconnu', () async {
      fakeBundle.content = validSkillsJson;
      expect(
        () => repository.getSkillById("unknown"),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('getSkills doit lever DataSourceException sur FlutterError', () async {
      fakeBundle.throwError = true;
      expect(() => repository.getSkills(), throwsA(isA<DataSourceException>()));
    });

    test(
      'getSkills doit lever DataSourceException sur FormatException (JSON corrompu)',
      () async {
        fakeBundle.content = "INVALID_JSON";
        expect(
          () => repository.getSkills(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );

    test(
      'getSkills doit lever DataSourceException si la racine n\'est pas une liste',
      () async {
        fakeBundle.content = json.encode({"id": "not_a_list"});
        expect(
          () => repository.getSkills(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );
  });
}
