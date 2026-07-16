import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_button2.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/auth/providers/google_sign_in_notifier.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/profile/presentation/widgets/profile_section.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppBar(
              title: const Text("My Profile"),
              shape: const Border(
                bottom: BorderSide(color: AppColors.border, width: 2),
              ),
            ),
            const ProfileSection(),
            const SizedBox(height: 10),
            Divider(color: AppColors.border, thickness: 1, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "My notes",
                  size: FontSizes.xxl,
                  weight: FontWeight.w600,
                ),
                CustomText(
                  text: "8 notes",
                  size: FontSizes.lg,
                  weight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 513,
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return PdfContainer();
                },
              ),
            ),
            const SizedBox(height: 15),
            Consumer(
              builder: (context, ref, child) {
                ref.listen<AsyncValue<void>>(googleSignInProvider, (
                  previous,
                  next,
                ) {
                  next.whenOrNull(
                    error: (error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                });
                final signOutState = ref.watch(googleSignInProvider);
                final googleProvider = ref.read(googleSignInProvider.notifier);

                return CustomButton2(
                  onPressed: signOutState.isLoading
                      ? null
                      : () => googleProvider.signOut(),
                  text: signOutState.isLoading ? "Signing Out..." : "Sign Out",
                  width: double.infinity,
                  height: 48,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
