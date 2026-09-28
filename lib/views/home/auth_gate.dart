import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grin_users/views/home/user_list_screen.dart';
import '../../repositories/auth_repository.dart';
import '../auth/login_screen.dart';


class AuthGate extends StatelessWidget {
  final AuthRepository authRepository;
  const AuthGate({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authRepository.authStateChanges,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasData) return const UserListScreen();
        return const LoginScreen();
      },
    );
  }
}