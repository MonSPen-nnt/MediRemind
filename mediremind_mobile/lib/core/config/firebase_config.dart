import 'package:firebase_core/firebase_core.dart';

abstract final class FirebaseConfig {
  static const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const _messagingSenderId =
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const _storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  static const _measurementId = String.fromEnvironment('FIREBASE_MEASUREMENT_ID');
  static const _iosBundleId = String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');

  static FirebaseOptions get options {
    final missing = <String>[
      if (_apiKey.isEmpty) 'FIREBASE_API_KEY',
      if (_appId.isEmpty) 'FIREBASE_APP_ID',
      if (_messagingSenderId.isEmpty) 'FIREBASE_MESSAGING_SENDER_ID',
      if (_projectId.isEmpty) 'FIREBASE_PROJECT_ID',
    ];

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing Firebase config: ${missing.join(', ')}. '
        'Pass them with --dart-define or run flutterfire configure and '
        'replace FirebaseConfig.options with DefaultFirebaseOptions.currentPlatform.',
      );
    }

    return FirebaseOptions(
      apiKey: _apiKey,
      appId: _appId,
      messagingSenderId: _messagingSenderId,
      projectId: _projectId,
      authDomain: _authDomain.isEmpty ? null : _authDomain,
      storageBucket: _storageBucket.isEmpty ? null : _storageBucket,
      measurementId: _measurementId.isEmpty ? null : _measurementId,
      iosBundleId: _iosBundleId.isEmpty ? null : _iosBundleId,
    );
  }
}

