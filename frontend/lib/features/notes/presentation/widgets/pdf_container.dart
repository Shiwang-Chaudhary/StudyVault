import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/notes_model.dart';

class PdfContainer extends StatelessWidget {
  final Note? note;
  final String title;
  final String subtitle;
  final String rating;
  final String likes;
  final String downloads;
  final Color iconColor;
  final Color iconBgColor;
  final double? height;

  const PdfContainer({
    super.key,
    this.note,
    this.title = "Operating Systems Unit 2 — Deadlocks",
    this.subtitle = "CSE · Semester IV",
    this.rating = "4.8",
    this.likes = "132",
    this.downloads = "540",
    this.iconColor = AppColors.accentCoral,
    this.iconBgColor = AppColors.accentCoralMuted,
    this.height = 93,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
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
              color: iconBgColor,
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.picture_as_pdf, size: 35, color: iconColor),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: note?.title ?? title,
                    size: FontSizes.lg,
                    weight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    text:
                        "${note?.branch ?? "CSE"} · Semester ${note?.semester ?? "IV"}",
                    size: FontSizes.md,
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
                      CustomText(
                        text: note?.ratingCount.toString() ?? rating,
                        size: FontSizes.md,
                        weight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.favorite_border,
                        color: AppColors.accentCoral,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: note?.likeCount.toString() ?? likes,
                        size: FontSizes.md,
                        weight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.download_outlined,
                        color: AppColors.success,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: note?.downloadCount.toString() ?? downloads,
                        size: FontSizes.md,
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
