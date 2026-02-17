class Skill {
  final String id;
  final String name;
  final String categoryId;

  Skill({required this.id, required this.name, required this.categoryId});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      categoryId: json['categoryId'],
    );
  }
}
