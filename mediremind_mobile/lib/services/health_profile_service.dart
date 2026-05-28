import '../data/repositories/health_profile_repository.dart';
import '../models/health_profile.dart';

class HealthProfileService {
  HealthProfileService({HealthProfileRepository? repository})
    : _repository = repository ?? HealthProfileRepository();

  final HealthProfileRepository _repository;

  Future<HealthProfile> getProfile(String id) {
    return _repository.getProfile(id);
  }

  Future<HealthProfile> createProfile(HealthProfile profile) {
    return _repository.saveProfile(profile);
  }
}
