import 'package:portfolio_steve/domain/models/contact.model.dart';

class Profile {
  final String name;
  final String photo;
  final String location;
  final String availability;
  final Contact contact;
  final String bioTitle;
  final String bioContent;
  final List<String> softSkills;
  final List<String> interests;

  Profile({
    required this.name,
    required this.photo,
    required this.location,
    required this.availability,
    required this.contact,
    required this.bioTitle,
    required this.bioContent,
    required this.softSkills,
    required this.interests,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final identity = json['identity'];
    final bioData = json['bio'];

    return Profile(
      name: identity['name'],
      photo: identity['photo'],
      location: identity['location'],
      availability: identity['availability'],
      contact: Contact.fromJson(json['contact']),
      bioTitle: bioData['title'],
      bioContent: bioData['content'],
      softSkills: List<String>.from(json['softSkills']),
      interests: List<String>.from(json['interests']),
    );
  }
}
