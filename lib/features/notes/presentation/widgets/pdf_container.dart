import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class PdfContainer extends StatelessWidget {
  const PdfContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: 150,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 6, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 70,
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: AppColors.accentCoralMuted,
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              size: 35,
              color: AppColors.accentCoral,
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 280,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Operating Systems Unit 2 — Deadlocks",
                    size: FontSizes.xl,
                    weight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    text: "CSE · Semester IV",
                    size: FontSizes.lg,
                    weight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_outline,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      const CustomText(
                        text: "4.8",
                        size: FontSizes.lg,
                        weight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.favorite_border,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      const CustomText(
                        text: "132",
                        size: FontSizes.lg,
                        weight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.download_outlined,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      const CustomText(
                        text: "540",
                        size: FontSizes.lg,
                        weight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
