import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: AppColors.textTertiary,
              size: 20,
            ),
            CustomText(
              text: "You can change this anytime from your profile.",
              size: FontSizes.md,
              weight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
