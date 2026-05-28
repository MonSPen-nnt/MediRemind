import 'package:flutter/foundation.dart';

abstract final class ApiConfig {
  /// Full base URL override, e.g. http://192.168.1.10:3001 (no trailing slash).
  static const _definedBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// PC LAN IP when testing on a physical Android device (same Wi-Fi).
  /// Example: flutter run --dart-define=DEV_HOST=192.168.1.10
  static const _devHost = String.fromEnvironment('DEV_HOST');

  static String get baseUrl {
    final raw = _definedBaseUrl.isNotEmpty
        ? _definedBaseUrl
        : _defaultBaseUrl();
    return _stripTrailingSlash(raw);
  }

  static String _defaultBaseUrl() {
    if (kIsWeb) return 'http://localhost:3001';
    if (defaultTargetPlatform == TargetPlatform.android) {
      final host = _devHost.isNotEmpty ? _devHost : '10.0.2.2';
      return 'http://$host:3001';
    }
    return 'http://localhost:3001';
  }

  static String _stripTrailingSlash(String url) {
    var value = url.trim();
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  static Uri endpoint(String path) {
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('$baseUrl/$normalized');
  }
}

