import 'package:flutter/material.dart';
import 'package:portfolio_steve/domain/entities/experience.entity.dart';
import 'package:portfolio_steve/domain/usescases/experiences.usecase.dart';
import 'package:portfolio_steve/domain/usescases/experience.usecase.dart';

class ExperienceProvider extends ChangeNotifier {
  final GetExperiences getExperiences;
  final GetExperience getExperienceById;

  ExperienceProvider({
    required this.getExperiences,
    required this.getExperienceById,
  });

  // État pour la liste
  List<ExperienceDetails> _experiences = [];
  bool _isLoadingList = false;
  String? _error;

  // État pour le détail (si tu as une page dédiée à une expérience)
  ExperienceDetails? _selectedExperience;
  bool _isLoadingDetail = false;

  // Getters
  List<ExperienceDetails> get experiences => _experiences;
  bool get isLoadingList => _isLoadingList;
  ExperienceDetails? get selectedExperience => _selectedExperience;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get errorMessage => _error;

  // Méthodes

  Future<void> loadAllExperiences() async {
    try {
      _isLoadingList = true;
      notifyListeners();
      _experiences = await getExperiences.execute();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  Future<void> loadSingleExperience(String id) async {
    try {
      _isLoadingDetail = true;
      _selectedExperience = null;
      notifyListeners();

      _selectedExperience = await getExperienceById.execute(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }
}
