import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    final UserCredential credential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final UserCredential credential =
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}