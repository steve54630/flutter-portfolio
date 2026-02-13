import 'package:flutter/material.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/repositories/skill.repository.dart';

class SkillProvider extends ChangeNotifier {
  final ISkillRepository repository;

  SkillProvider({required this.repository});

  List<Skill> _skills = [];
  bool _isLoading = false;
  String? _error;
  Skill? _skill;

  // Getters
  List<Skill> get skills => _skills;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Skill? get skill => _skill;

  // Getter utile pour filtrer par catégorie dans l'UI
  List<Skill> getSkillsByCategory(String categoryId) {
    return _skills.where((s) => s.categoryId == categoryId).toList();
  }

  Future<void> loadSkill(String skillId) async {
    try {
      _error = null;
      _isLoading = true;
      notifyListeners();

      _skill = await repository.getSkillById(skillId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSkills() async {
    try {
      _error = null;
      _isLoading = true;
      notifyListeners();

      _skills = await repository.getSkills();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
