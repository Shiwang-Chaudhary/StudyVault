import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/core/config/app_themes.dart';
import 'package:study_vault/core/navigation/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: StudyVault()));
}

class StudyVault extends StatelessWidget {
  const StudyVault({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteMandi',
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
