import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_steve/domain/exceptions/datasource.exception.dart';
import 'package:portfolio_steve/domain/models/profile.model.dart';
import 'package:portfolio_steve/domain/repositories/profile.repository.dart';

class JsonProfileRepository implements IProfileRepository {
  static const String assetPath = 'data/profile.json';
  final AssetBundle bundle;

  JsonProfileRepository({AssetBundle? bundle}) : bundle = bundle ?? rootBundle;

  @override
  Future<Profile> getProfile() async {
    try {
      final String response = await bundle.loadString(assetPath);
      final Map<String, dynamic> data = json.decode(response);
      return Profile.fromJson(data);
    } on FlutterError catch (e) {
      throw DataSourceException("Erreur de chargement des données: $e");
    } on FormatException catch (e) {
      throw DataSourceException("Erreur de format des données: $e");
    } catch (e) {
      throw DataSourceException("Erreur inattendue: $e");
    }
  }
}
