import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/providers/auth_repo_provider.dart';
import 'package:study_vault/features/auth/providers/user_profile_provider.dart';

class GoogleSignInProvider extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.sigInWithGoogle();
    });
    //Re reuns the userProfileProvider to fetch the user profile from backend after sign in
    ref.invalidate(userProfileProvider);
    log("SIGN IN END");
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signOut();
    });
  }
}

final googleSignInProvider = AsyncNotifierProvider<GoogleSignInProvider, void>(
  () {
    return GoogleSignInProvider();
  },
);
