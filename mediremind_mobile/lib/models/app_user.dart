class AppUser {
  const AppUser({
    required this.email,
    required this.fullName,
    required this.emailVerified,
    this.userId,
    this.firebaseUid,
  });

  final String? userId;
  final String? firebaseUid;
  final String email;
  final String fullName;
  final bool emailVerified;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: json['user_id'] as String?,
      firebaseUid: json['firebaseUid'] as String?,
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }
}

