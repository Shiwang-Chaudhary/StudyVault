import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:study_vault/features/auth/presentation/widgets/google_container.dart';
import 'package:study_vault/features/auth/providers/google_sign_in_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(googleSignInProvider);
    final authNotifier = ref.read(googleSignInProvider.notifier);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 200),
            Container(
              height: 95,
              width: 95,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 55),
            ),
            const SizedBox(height: 20),
            CustomText(
              text: 'Welcome to StudyVault',
              size: FontSizes.xxxl,
              weight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            CustomText(
              text: 'Sign in to continue',
              size: FontSizes.lg,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
            GoogleContainer(
              isLoading: authState.isLoading,
              onTap: () {
                authNotifier.signIn();
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.border,
                    thickness: 1,
                    indent: 20,
                    endIndent: 10,
                  ),
                ),
                CustomText(
                  text: "why Google sign-in?",
                  size: FontSizes.md,
                  color: AppColors.textSecondary,
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.border,
                    thickness: 1,
                    indent: 20,
                    endIndent: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomText(
              text: "No password to remember or reset.",
              size: FontSizes.lg,
              color: AppColors.textSecondary,
            ),
            CustomText(
              text: "Your account is secured by Google.",
              size: FontSizes.lg,
              color: AppColors.textSecondary,
            ),
            Spacer(),
            SizedBox(
              width: 300,
              child: CustomText(
                text:
                    "By continuing, you agree to StudyVault's Terms of Service and Privacy Policy.",
                size: FontSizes.md,
                color: AppColors.textSecondary,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // CustomText(
            //   text: "No password to remember or reset.",
            //   size: FontSizes.lg,
            //   color: AppColors.textSecondary,
            // ),
          ],
        ),
      ),
    );
  }
}
