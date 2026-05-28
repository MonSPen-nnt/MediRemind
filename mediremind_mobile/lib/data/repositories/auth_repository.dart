import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../models/app_user.dart';
import '../remote/auth_remote_data_source.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    AuthRemoteDataSource? remoteDataSource,
  })  : _firebaseAuth = firebaseAuth,
        _remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl();

  final FirebaseAuth? _firebaseAuth;
  final AuthRemoteDataSource _remoteDataSource;

  FirebaseAuth get _auth {
    if (_firebaseAuth != null) return _firebaseAuth;
    if (Firebase.apps.isEmpty) {
      throw Exception(
        'Chua cau hinh Firebase. Hay them Firebase config hoac chay app voi --dart-define.',
      );
    }
    return FirebaseAuth.instance;
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Khong the tao tai khoan Firebase.');
      }

      await user.updateDisplayName(fullName);
      await user.sendEmailVerification();

      final idToken = await user.getIdToken(true);
      if (idToken == null) {
        throw Exception('Khong lay duoc Firebase ID token.');
      }

      await _remoteDataSource.syncFirebaseUser(
        idToken: idToken,
        fullName: fullName,
      );
    } on FirebaseAuthException catch (error) {
      throw Exception(_mapFirebaseAuthError(error));
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Dang nhap Firebase that bai.');
      }

      await user.reload();
      final refreshedUser = _auth.currentUser;
      if (refreshedUser == null) {
        throw Exception('Khong tim thay phien dang nhap.');
      }

      if (!refreshedUser.emailVerified) {
        await refreshedUser.sendEmailVerification();
        await _auth.signOut();
        throw Exception('Vui long xac minh email truoc khi dang nhap.');
      }

      final idToken = await refreshedUser.getIdToken(true);
      if (idToken == null) {
        throw Exception('Khong lay duoc Firebase ID token.');
      }

      return _remoteDataSource.syncFirebaseUser(
        idToken: idToken,
        fullName: refreshedUser.displayName,
      );
    } on FirebaseAuthException catch (error) {
      throw Exception(_mapFirebaseAuthError(error));
    }
  }

  Future<void> sendPasswordResetEmail(String email) {
    try {
      return _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw Exception(_mapFirebaseAuthError(error));
    }
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'configuration-not-found':
        return 'Firebase Authentication chua duoc bat. Vao Firebase Console > Authentication > Sign-in method va bat Email/Password.';
      case 'email-already-in-use':
        return 'Email nay da duoc dang ky.';
      case 'invalid-email':
        return 'Email khong hop le.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email hoac mat khau khong dung.';
      case 'weak-password':
        return 'Mat khau qua yeu. Hay dung it nhat 6 ky tu.';
      case 'network-request-failed':
        return 'Khong ket noi duoc Firebase. Kiem tra mang va thu lai.';
      default:
        return error.message ?? 'Loi Firebase Auth: ${error.code}';
    }
  }
}

