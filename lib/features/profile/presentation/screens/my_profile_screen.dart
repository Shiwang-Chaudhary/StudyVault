import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_button2.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';

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
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.primaryMuted,
              child: CustomText(
                text: "SC",
                size: FontSizes.hero,
                color: AppColors.borderFocused,
              ),
            ),
            const SizedBox(height: 10),
            CustomText(
              text: "Shiwang Chaudhary",
              size: FontSizes.xxl,
              weight: FontWeight.w600,
            ),
            CustomText(
              text: "Gurugram University | CSE",
              size: FontSizes.lg,
              weight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMuted,
                    // border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomText(
                    text: "Semster IV",
                    size: FontSizes.md,
                    weight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                CustomText(
                  text: "Joined Jan 2026",
                  size: FontSizes.md,
                  weight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    height: 76,
                    margin: const EdgeInsets.only(top: 10, left: 6, right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        // horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        children: [
                          CustomText(
                            text: "540",
                            size: FontSizes.xxl,
                            color: AppColors.textPrimary,
                          ),
                          CustomText(
                            text: "Downloads",
                            size: FontSizes.md,
                            weight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
            CustomButton2(
              onPressed: () {},
              text: "Sign Out",
              width: double.infinity,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
