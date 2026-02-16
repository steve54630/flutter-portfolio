class Project {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String mainTech;
  final List<String> skillIds;
  final List<String> strengths;
  final String link;
  final String? demo;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.mainTech,
    required this.skillIds,
    required this.strengths,
    required this.link,
    this.demo,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: List<String>.from(json['images']),
      mainTech: json['mainTech'],
      skillIds: List<String>.from(json['skillIds']),
      strengths: List<String>.from(json['strengths']),
      link: json['link'],
      demo: json['demo'] as String?,
    );
  }
}
