import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/app_user.dart';

abstract class AuthRemoteDataSource {
  Future<AppUser> syncFirebaseUser({
    required String idToken,
    String? fullName,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  static const _baseUrl = 'http://10.0.2.2:3001';
  final http.Client _client;

  @override
  Future<AppUser> syncFirebaseUser({
    required String idToken,
    String? fullName,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/firebase'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken, 'fullName': fullName}),
    );

    if (response.statusCode != 200) {
      throw Exception('Dong bo tai khoan that bai: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return AppUser.fromJson(body['user'] as Map<String, dynamic>);
  }
}

