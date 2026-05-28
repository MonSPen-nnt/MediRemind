import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';
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

  final http.Client _client;

  @override
  Future<AppUser> syncFirebaseUser({
    required String idToken,
    String? fullName,
  }) async {
    final url = ApiConfig.endpoint('api/auth/firebase');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken, 'fullName': fullName}),
    );

    if (response.statusCode != 200) {
      final detail = response.body.trim();
      final suffix = detail.isNotEmpty ? ': $detail' : '';
      throw Exception(
        'Dong bo tai khoan that bai (${response.statusCode}) '
        'tai $url$suffix',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return AppUser.fromJson(body['user'] as Map<String, dynamic>);
  }
}

