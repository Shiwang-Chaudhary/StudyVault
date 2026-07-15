import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_vault/core/config/app_prefrences.dart';
import 'package:study_vault/core/config/app_themes.dart';
import 'package:study_vault/core/navigation/auth_gate.dart';
import 'package:study_vault/features/auth/presentation/screens/get_started_screen.dart';
import 'package:study_vault/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final bool isFirstLaunch = await AppPreferences.isFirstLaunch();
  runApp(ProviderScope(child: StudyVault(isFirstLaunch: isFirstLaunch)));
}

class StudyVault extends StatelessWidget {
  final bool isFirstLaunch;
  const StudyVault({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyVault',
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: isFirstLaunch ? const GetStartedScreen() : const AuthGate(),
    );
  }
}
