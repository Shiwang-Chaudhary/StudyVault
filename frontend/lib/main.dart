import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/core/config/app_themes.dart';
import 'package:study_vault/core/navigation/auth_gate.dart';
import 'package:study_vault/features/auth/presentation/screens/get_started_screen.dart';
import 'package:study_vault/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: StudyVault()));
}

class StudyVault extends StatelessWidget {
  const StudyVault({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyVault',
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const GetStartedScreen(),
    );
  }
}
