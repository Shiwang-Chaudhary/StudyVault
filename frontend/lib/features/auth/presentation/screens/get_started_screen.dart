import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_button.dart';
import 'package:study_vault/core/widgets/custom_list_tile.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/auth/presentation/screens/login_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
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
                text: 'StudyVault',
                size: FontSizes.hero,
                weight: FontWeight.w700,
              ),
              const SizedBox(height: 10),
              CustomText(
                text: 'Notes made by students',
                size: FontSizes.lg,
                color: AppColors.textSecondary,
              ),
              CustomText(
                text: 'shared with students',
                size: FontSizes.lg,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 25),
              CustomListTile(
                title: 'Upload your notes',
                subtitle: 'Help juniors, build your name',
                leadingColor: AppColors.accentCoralMuted,
                iconColor: AppColors.accentCoral,
                icon: Icons.picture_as_pdf,
              ),
              CustomListTile(
                title: 'Find notes by your college',
                subtitle: 'Filtered by subject and semester',
                leadingColor: AppColors.infoMuted,
                iconColor: AppColors.info,
                icon: Icons.search,
              ),
              CustomListTile(
                title: 'Rated by real students',
                subtitle: 'No more guessing whats good',
                leadingColor: AppColors.accentTealMuted,
                iconColor: AppColors.accentTeal,
                icon: Icons.thumb_up_outlined,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: "Get Started",
                  height: 55,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                ),
              ),
              CustomText(
                text: "Free to join · No charges in v1",
                size: FontSizes.md,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
