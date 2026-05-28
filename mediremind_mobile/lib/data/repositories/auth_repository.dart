import 'package:firebase_auth/firebase_auth.dart';

import '../../models/app_user.dart';
import '../remote/auth_remote_data_source.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    AuthRemoteDataSource? remoteDataSource,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl();

  final FirebaseAuth _firebaseAuth;
  final AuthRemoteDataSource _remoteDataSource;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
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
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Dang nhap Firebase that bai.');
    }

    await user.reload();
    final refreshedUser = _firebaseAuth.currentUser;
    if (refreshedUser == null) {
      throw Exception('Khong tim thay phien dang nhap.');
    }

    if (!refreshedUser.emailVerified) {
      await refreshedUser.sendEmailVerification();
      await _firebaseAuth.signOut();
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
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() {
    return _firebaseAuth.signOut();
  }
}

