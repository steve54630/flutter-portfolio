import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portfolio_steve/domain/entities/project.entity.dart';
import 'package:portfolio_steve/domain/models/project.model.dart';
import 'package:portfolio_steve/domain/models/skill.model.dart';
import 'package:portfolio_steve/domain/usescases/project.usecase.dart';
import 'package:portfolio_steve/domain/usescases/projects.usecase.dart';
import 'package:portfolio_steve/presentation/providers/project.provider.dart';

class MockGetProjects extends Mock implements GetProjects {}

class MockGetProject extends Mock implements GetProject {}

void main() {
  late ProjectProvider provider;
  late MockGetProjects mockGetProjects;
  late MockGetProject mockGetProject;

  setUp(() {
    mockGetProjects = MockGetProjects();
    mockGetProject = MockGetProject();
    provider = ProjectProvider(
      getProjects: mockGetProjects,
      getProjectById: mockGetProject,
    );
  });

  final tProjectDetails = ProjectDetails(
    project: Project(
      id: "p1",
      title: "Portfolio",
      description: "My portfolio",
      images: [],
      mainTech: "s1",
      skillIds: ["s1"],
      strengths: [],
      link: "",
    ),
    mainTech: Skill(id: "s1", name: "Flutter", categoryId: "fw"),
    skills: [Skill(id: "s1", name: "Flutter", categoryId: "fw")],
  );

  group('ProjectProvider - List Management', () {
    test('doit charger les projets et mettre à jour isLoadingList', () async {
      // Arrange
      when(
        () => mockGetProjects.execute(),
      ).thenAnswer((_) async => [tProjectDetails]);

      // Act
      final future = provider.loadAllProjects();

      // Assert pendant le chargement
      expect(provider.isLoadingList, true);

      await future;

      // Assert après chargement
      expect(provider.projects, [tProjectDetails]);
      expect(provider.isLoadingList, false);
      verify(() => mockGetProjects.execute()).called(1);
    });

    test('doit gérer l\'erreur et stopper le chargement', () async {
      // Arrange
      when(() => mockGetProjects.execute()).thenThrow(Exception("Error"));

      // Act
      await provider.loadAllProjects();

      // Assert
      expect(provider.isLoadingList, false);
      expect(provider.projects, []);
    });
  });

  group('ProjectProvider - Detail Management', () {
    test(
      'doit charger un projet solo et reset le projet sélectionné au début',
      () async {
        // Arrange
        const tId = "p1";
        when(
          () => mockGetProject.execute(tId),
        ).thenAnswer((_) async => tProjectDetails);

        // Act
        final future = provider.loadSingleProject(tId);

        // On vérifie que le projet précédent est bien effacé avant le nouveau fetch
        expect(provider.selectedProject, null);
        expect(provider.isLoadingDetail, true);

        await future;

        // Assert
        expect(provider.selectedProject, tProjectDetails);
        expect(provider.isLoadingDetail, false);
        verify(() => mockGetProject.execute(tId)).called(1);
      },
    );

    test(
      'doit stopper le chargement du détail même en cas d\'erreur',
      () async {
        // Arrange
        when(
          () => mockGetProject.execute(any()),
        ).thenThrow(Exception("Not Found"));

        // Act
        await provider.loadSingleProject("invalid_id");

        // Assert
        expect(provider.isLoadingDetail, false);
        expect(provider.selectedProject, null);
      },
    );
  });
}
