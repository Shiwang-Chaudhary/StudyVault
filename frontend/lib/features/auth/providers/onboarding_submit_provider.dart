import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/data/onboarding_model.dart';
import 'package:study_vault/features/auth/providers/auth_repo_provider.dart';
import 'package:study_vault/features/auth/providers/user_profile_provider.dart';

class OnboardingSubmitNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submitOnboarding(OnboardingModel data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.completeOnboarding(data);
    });
    if (!state.hasError) {
      //Re reuns the userProfileProvider to fetch the user profile from backend after onboarding
      ref.invalidate(userProfileProvider);
    }
  }
}

final onboardingSubmitProvider =
    AsyncNotifierProvider<OnboardingSubmitNotifier, void>(() {
      return OnboardingSubmitNotifier();
    });
