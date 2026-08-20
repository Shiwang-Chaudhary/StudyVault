import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:study_vault/core/navigation/main_screen.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

import 'package:study_vault/features/auth/presentation/screens/login_screen.dart';
import 'package:study_vault/features/auth/presentation/screens/onboarding_screen.dart';

import 'package:study_vault/features/auth/providers/auth_state_provider.dart';
import 'package:study_vault/features/auth/providers/user_profile_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log("AuthGate build");
    final authState = ref.watch(authStateProvider);
    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (error, stackTrace) => Scaffold(
        body: Center(child: CustomText(text: error.toString())),
      ),

      data: (firebaseUser) {
        // User is not logged in
        log("Firebase user: ${firebaseUser?.uid}");
        if (firebaseUser == null) {
          log("Returning GetStartedScreen");
          return const LoginScreen();
        }
        log("Watching userProfileProvider");
        // final firebaseUser = firebaseUser;
        // User is logged in, fetch profile from backend
        final userProfile = ref.watch(userProfileProvider);

        return userProfile.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),

          error: (error, stackTrace) => Scaffold(
            body: Center(child: CustomText(text: error.toString())),
          ),

          data: (user) {
            log("User onboarding status: ${user.hasCompletedOnboarding}");
            if (!user.hasCompletedOnboarding) {
              return const OnboardingScreen();
            }

            return const MainScreen();
          },
        );
      },
    );
  }
}
