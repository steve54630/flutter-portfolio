import 'package:flutter/material.dart';
import 'package:portfolio_steve/domain/models/profile.model.dart';
import 'package:portfolio_steve/domain/repositories/profile.repository.dart';

class ProfileProvider extends ChangeNotifier {
  final IProfileRepository repository;

  ProfileProvider({required this.repository});

  Profile? _profile;
  bool _isLoading = false;
  String? _error;

  // Getters
  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile() async {
    try {
      _error = null;
      _isLoading = true;
      notifyListeners();

      _profile = await repository.getProfile();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
