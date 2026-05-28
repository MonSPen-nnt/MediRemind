import 'package:flutter/material.dart';

enum DoseStatus { taken, upcoming, pending, missed, skipped }

/// Một liều thuốc trong ngày — dữ liệu demo cho Trang chủ.
class MedicationDose {
  const MedicationDose({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.scheduledTime,
    required this.status,
    this.note,
    this.icon = Icons.medication_liquid_rounded,
  });

  final String id;
  final String medicineName;
  final String dosage;
  final TimeOfDay scheduledTime;
  final DoseStatus status;
  final String? note;
  final IconData icon;

  String get timeLabel {
    final h = scheduledTime.hour.toString().padLeft(2, '0');
    final m = scheduledTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  MedicationDose copyWith({DoseStatus? status}) {
    return MedicationDose(
      id: id,
      medicineName: medicineName,
      dosage: dosage,
      scheduledTime: scheduledTime,
      status: status ?? this.status,
      note: note,
      icon: icon,
    );
  }
}
