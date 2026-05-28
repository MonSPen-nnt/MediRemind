/// Người thân đã / đang liên kết.
class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    this.status = FamilyLinkStatus.linked,
    this.canViewSchedule = true,
    this.canReceiveAlerts = true,
    this.canEditSchedule = false,
  });

  final String id;
  final String name;
  final String relationship;
  final String phone;
  final FamilyLinkStatus status;
  final bool canViewSchedule;
  final bool canReceiveAlerts;
  final bool canEditSchedule;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

enum FamilyLinkStatus { linked, pending, incoming }
