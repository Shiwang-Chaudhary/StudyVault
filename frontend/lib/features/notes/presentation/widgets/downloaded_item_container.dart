import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/models/local_pdf_model.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';

class DownloadedItemContainer extends StatelessWidget {
  final LocalPdfModel? pdf;
  final Note? note;
  final String title;
  final String subtitle;
  final String rating;
  final String likes;
  final String downloads;
  final Color iconColor;
  final Color iconBgColor;
  final double? height;
  const DownloadedItemContainer({
    super.key,
    this.pdf,
    this.note,
    this.title = "Operating Systems Unit 2 — Deadlocks",
    this.subtitle = "CSE · Semester IV",
    this.rating = "4.8",
    this.likes = "132",
    this.downloads = "540",
    this.iconColor = AppColors.accentCoral,
    this.iconBgColor = AppColors.accentCoralMuted,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      margin: const EdgeInsets.only(right: 6, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
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
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Center(
                    child: CustomText(
                      text: pdf?.title ?? title,
                      maxLines: 3,
                      size: FontSizes.lg,
                      weight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete, color: AppColors.error),
              ),
            ],
          ),

          Divider(color: AppColors.info, thickness: 1.2),
        ],
      ),
    );
  }
}
