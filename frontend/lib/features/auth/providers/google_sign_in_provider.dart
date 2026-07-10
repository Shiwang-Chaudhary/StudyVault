import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/providers/auth_repo_provider.dart';

class GoogleSignInProvider extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.sigInWithGoogle();
    });
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
