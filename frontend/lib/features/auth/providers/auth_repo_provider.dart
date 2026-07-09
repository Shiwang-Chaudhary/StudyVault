import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepoProvider>((ref) {
  return AuthRepoProvider(FirebaseAuth.instance);
});
