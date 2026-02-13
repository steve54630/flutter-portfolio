import 'package:flutter/material.dart';
import 'package:portfolio_steve/domain/entities/project.entity.dart';
import 'package:portfolio_steve/domain/usescases/project.usecase.dart';
import 'package:portfolio_steve/domain/usescases/projects.usecase.dart';

class ProjectProvider extends ChangeNotifier {
  final GetProjects getProjects;
  final GetProject getProjectById;

  ProjectProvider({required this.getProjects, required this.getProjectById});

  // État pour la liste
  List<ProjectDetails> _projects = [];
  bool _isLoadingList = false;

  // État pour le détail
  ProjectDetails? _selectedProject;
  bool _isLoadingDetail = false;

  String? _error;

  // Getters

  List<ProjectDetails> get projects => _projects;
  bool get isLoadingList => _isLoadingList;
  ProjectDetails? get selectedProject => _selectedProject;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get errorMessage => _error;

  // Méthodes
  Future<void> loadAllProjects() async {
    try {
      _isLoadingList = true;
      notifyListeners();
      _projects = await getProjects.execute();
      _isLoadingList = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  Future<void> loadSingleProject(String id) async {
    try {
      _isLoadingDetail = true;
      _selectedProject = null; // Reset avant chargement
      notifyListeners();
      _selectedProject = await getProjectById.execute(id);
      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }
}
