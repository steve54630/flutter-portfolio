import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';
import 'package:portfolio_steve/domain/models/experience.model.dart';
import 'package:portfolio_steve/domain/repositories/experience.repository.dart';

class JsonExperienceRepository implements IExperienceRepository {
  static const String assetPath = 'data/experiences.json';
  final AssetBundle bundle;

  JsonExperienceRepository({AssetBundle? bundle})
    : bundle = bundle ?? rootBundle;

  @override
  Future<Experience> getExperienceById(String id) async {
    final experiences = await getExperiences();
    return experiences.firstWhere(
      (experience) => experience.id == id,
      orElse: () => throw NotFoundException("Experience", id),
    );
  }

  @override
  Future<List<Experience>> getExperiences() async {
    try {
      final String response = await bundle.loadString(assetPath);
      final List<dynamic> data = json.decode(response);
      return data.map<Experience>((json) => Experience.fromJson(json)).toList();
    } on FlutterError catch (e) {
      throw DataSourceException("Erreur de chargement des données: $e");
    } on FormatException catch (e) {
      throw DataSourceException("Erreur de format des données: $e");
    } catch (e) {
      throw DataSourceException("Erreur inattendue: $e");
    }
  }
}
