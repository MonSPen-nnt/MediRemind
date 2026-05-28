import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/health_profile.dart';

abstract class HealthProfileRemoteDataSource {
  Future<HealthProfile> fetchHealthProfile(String id);
  Future<HealthProfile> createHealthProfile(HealthProfile profile);
}

class HealthProfileRemoteDataSourceImpl
    implements HealthProfileRemoteDataSource {
  HealthProfileRemoteDataSourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  static const _baseUrl = 'http://10.0.2.2:3001';
  final http.Client _client;

  @override
  Future<HealthProfile> fetchHealthProfile(String id) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/api/health-profile/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể tải hồ sơ: ${response.statusCode}');
    }

    return HealthProfile.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  @override
  Future<HealthProfile> createHealthProfile(HealthProfile profile) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/health-profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Tạo hồ sơ thất bại: ${response.statusCode}');
    }

    return HealthProfile.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
