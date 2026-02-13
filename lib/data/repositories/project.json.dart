import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/exceptions/notfound.exception.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';
import 'package:portfolio_steve/domain/repositories/project.repository.dart';

class JsonProjectRepository implements IProjectRepository {
  static const String assetPath = 'data/projects.json';

  @override
  Future<Project> getProjectById(String id) async {
    final projects = await getProjects();
    return projects.firstWhere(
      (project) => project.id == id,
      orElse: () => throw NotFoundException("Project", id),
    );
  }

  @override
  Future<List<Project>> getProjects() async {
    try {
      final String response = await rootBundle.loadString(assetPath);
      final List<dynamic> data = json.decode(response);

      return data.map<Project>((json) => Project.fromJson(json)).toList();
    } on FlutterError catch (e) {
      throw DataSourceException("Erreur de chargement des données: $e");
    } on FormatException catch (e) {
      throw DataSourceException("Erreur de format des données: $e");
    } catch (e) {
      rethrow;
    }
  }
}
