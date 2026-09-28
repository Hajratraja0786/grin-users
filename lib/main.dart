import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grin_users/views/home/auth_gate.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'repositories/auth_repository.dart';
import 'repositories/user_repository.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/user_list_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository(AuthService());
    final userRepo = UserRepository(ApiService());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepo)),
        ChangeNotifierProvider(create: (_) => UserListViewModel(userRepo)),
      ],
      child: MaterialApp(
        title: 'Grin User',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: AuthGate(authRepository: authRepo),
      ),
    );
  }
}