/// Dữ liệu hồ sơ sức khỏe người dùng.
class HealthProfile {
  const HealthProfile({
    this.displayName = '',
    this.dateOfBirth,
    this.gender,
    this.heightCm = 165,
    this.weightKg = 60,
    this.bloodType,
    this.allergies = '',
    this.conditions = const [],
    this.emergencyName = '',
    this.emergencyPhone = '',
  });

  final String displayName;
  final DateTime? dateOfBirth;
  final String? gender;
  final double heightCm;
  final double weightKg;
  final String? bloodType;
  final String allergies;
  final List<String> conditions;
  final String emergencyName;
  final String emergencyPhone;

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    var years = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      years--;
    }
    return years;
  }

  double get bmi {
    final h = heightCm / 100;
    if (h <= 0) return 0;
    return weightKg / (h * h);
  }

  HealthProfile copyWith({
    String? displayName,
    DateTime? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? bloodType,
    String? allergies,
    List<String>? conditions,
    String? emergencyName,
    String? emergencyPhone,
  }) {
    return HealthProfile(
      displayName: displayName ?? this.displayName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      conditions: conditions ?? this.conditions,
      emergencyName: emergencyName ?? this.emergencyName,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
    );
  }
}
