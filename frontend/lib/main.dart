import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:study_vault/core/config/app_prefrences.dart';
import 'package:study_vault/core/config/app_themes.dart';
import 'package:study_vault/core/navigation/auth_gate.dart';
import 'package:study_vault/core/storage/hive_providers.dart';
import 'package:study_vault/core/storage/hive_registrar.g.dart';
import 'package:study_vault/features/auth/presentation/screens/get_started_screen.dart';
import 'package:study_vault/features/notes/data/models/local_pdf_model.dart';
import 'package:study_vault/features/notes/data/models/pdf_history_model.dart';
import 'package:study_vault/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  final pdfBox = await Hive.openBox<LocalPdfModel>('pdf_documents');
  final pdfHistoryBox = await Hive.openBox<PdfHistoryModel>('pdf_history');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final bool isFirstLaunch = await AppPreferences.isFirstLaunch();
  runApp(
    ProviderScope(
      overrides: [
        pdfBoxProvider.overrideWithValue(pdfBox),
        pdfHistoryBoxProvider.overrideWithValue(pdfHistoryBox),
      ],
      child: StudyVault(isFirstLaunch: isFirstLaunch),
    ),
  );
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
