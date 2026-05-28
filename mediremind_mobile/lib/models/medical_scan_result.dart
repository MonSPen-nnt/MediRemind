/// Kết quả quét tài liệu y tế (mock UI — chưa OCR thật).
class MedicalScanResult {
  const MedicalScanResult({
    this.bloodType,
    this.conditions = const [],
    this.allergies = const [],
  });

  final String? bloodType;
  final List<String> conditions;
  final List<String> allergies;
}
