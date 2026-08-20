import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/data/user_model.dart';
import 'package:study_vault/features/auth/providers/auth_repo_provider.dart';

final userProfileProvider = FutureProvider.autoDispose<UserModel>((ref) async {
  log("userProfileProvider started");

  // This is the key line — by watching authStateProvider, this provider
  // now DEPENDS on Firebase auth state. Whenever Firebase emits a new
  // user (i.e. after Google sign-in), this provider automatically
  // re-runs and calls syncWithBackend() with the fresh token.
  // final firebaseUser = await ref.watch(authStateProvider.future);

  // if (firebaseUser == null) {
  //   throw Exception('Not authenticated');
  // }

  final authRepo = ref.read(authRepositoryProvider);
  final user = await authRepo.syncWithBackend();
  log("userProfileProvider completed: ${user.toJson()}");
  return user;
});
