class Contact {
  final String phone;
  final String email;
  final String linkedin;
  final String portfolio;

  Contact({
    required this.phone,
    required this.email,
    required this.linkedin,
    required this.portfolio,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email'],
      linkedin: json['linkedin'],
      portfolio: json['portfolio'],
    );
  }
}
