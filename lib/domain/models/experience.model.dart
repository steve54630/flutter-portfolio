class Experience {
  final String id;
  final String role;
  final String company;
  final String period;
  final String description;
  final List<String> skillIds;

  Experience({
    required this.id,
    required this.role,
    required this.company,
    required this.period,
    required this.description,
    required this.skillIds,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      role: json['role'],
      company: json['company'],
      period: json['period'],
      description: json['description'],
      skillIds: List<String>.from(json['skillIds']),
    );
  }
}
