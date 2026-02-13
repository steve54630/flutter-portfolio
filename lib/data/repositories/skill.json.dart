import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';

class JsonSkillRepository implements ISkillRepository {
  static const String assetPath = 'data/skills.json';

  @override
  Future<Skill> getSkillById(String id) async {
    final List<Skill> skills = await getSkills();
    return skills.firstWhere(
      (skill) => skill.id == id,
      orElse: () => throw NotFoundException("Skill", id),
    );
  }

  @override
  Future<List<Skill>> getSkills() async {
    try {
      final String response = await rootBundle.loadString(assetPath);
      final List<dynamic> data = json.decode(response);
      return data.map<Skill>((json) => Skill.fromJson(json)).toList();
    } on FlutterError catch (e) {
      throw DataSourceException("Erreur de chargement des compétences: $e");
    } on FormatException catch (e) {
      throw DataSourceException("Erreur de format des données: $e");
    } catch (e) {
      throw DataSourceException("Erreur inattendue: $e");
    }
  }
}
