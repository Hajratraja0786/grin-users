import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service;
  AuthRepository(this._service);

  User? get currentUser => _service.currentUser;
  Stream<User?> get authStateChanges => _service.authStateChanges;

  Future<User?> signUp(String email, String password) =>
      _service.signUp(email, password);

  Future<User?> login(String email, String password) =>
      _service.login(email, password);

  Future<void> logout() => _service.logout();
}