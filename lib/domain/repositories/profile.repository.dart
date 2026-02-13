import '../models/profile.model.dart';

abstract interface class IProfileRepository {
  Future<Profile> getProfile();
}
