import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_steve/data/repositories/project.json.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';

class FakeProjectBundle extends Fake implements AssetBundle {
  String? content;
  bool throwFlutterError = false;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (throwFlutterError) throw FlutterError("Asset not found");
    return content ?? '[]';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsonProjectRepository Coverage Tests', () {
    late JsonProjectRepository repository;
    late FakeProjectBundle fakeBundle;

    final validProjectsJson = json.encode([
      {
        "id": "p1",
        "title": "Project 1",
        "description": "Desc",
        "images": ["img.png"],
        "mainTech": "Flutter",
        "skillIds": ["s1"],
        "strengths": ["Fast"],
        "link": "https://link.com",
      },
    ]);

    setUp(() {
      fakeBundle = FakeProjectBundle();
      repository = JsonProjectRepository(bundle: fakeBundle);
    });

    test('getProjects doit parser correctement une liste valide', () async {
      fakeBundle.content = validProjectsJson;
      final result = await repository.getProjects();
      expect(result, isA<List<Project>>());
      expect(result.first.id, "p1");
    });

    test('getProjectById doit retourner le projet si l\'ID existe', () async {
      fakeBundle.content = validProjectsJson;
      final result = await repository.getProjectById("p1");
      expect(result.title, "Project 1");
    });

    test(
      'getProjects doit lever DataSourceException sur FlutterError',
      () async {
        fakeBundle.throwFlutterError = true;
        expect(
          () => repository.getProjects(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );

    test(
      'getProjects doit lever DataSourceException sur FormatException',
      () async {
        fakeBundle.content = "INVALID JSON";
        expect(
          () => repository.getProjects(),
          throwsA(isA<DataSourceException>()),
        );
      },
    );

    test('getProjectById doit lever NotFoundException si ID absent', () async {
      fakeBundle.content = validProjectsJson;
      expect(
        () => repository.getProjectById("unknown"),
        throwsA(isA<NotFoundException>()),
      );
    });
  });
}
