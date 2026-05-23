import '../models/health_profile.dart';
import '../services/health_profile_service.dart';

class HealthProfileController {
  HealthProfileController({HealthProfileService? service})
    : _service = service ?? HealthProfileService();

  final HealthProfileService _service;

  Future<HealthProfile> fetchProfile(String id) {
    return _service.getProfile(id);
  }

  Future<HealthProfile> createSampleProfile() {
    final profile = HealthProfile(
      displayName: 'Nguyen Van A',
      dateOfBirth: DateTime(1990, 6, 15),
      gender: 'Male',
      heightCm: 170,
      weightKg: 68,
      bloodType: 'O+',
      allergies: 'Không',
      conditions: ['Tăng huyết áp'],
      emergencyName: 'Le Thi B',
      emergencyPhone: '+84912345678',
    );
    return _service.createProfile(profile);
  }
}
