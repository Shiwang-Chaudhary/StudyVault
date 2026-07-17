import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class UploadFileDottedBorder extends StatelessWidget {
  final String? selectedFileName;
  final VoidCallback? onTap;
  const UploadFileDottedBorder({super.key, this.selectedFileName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(16),
          dashPattern: [8, 4],
          color: AppColors.surfaceElevated,
          strokeWidth: 2,
        ),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: selectedFileName != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 35,
                      color: AppColors.surfaceElevated,
                    ),
                    CustomText(
                      text: selectedFileName!,
                      size: FontSizes.lg,
                      weight: FontWeight.w500,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 35,
                      color: AppColors.surfaceElevated,
                    ),
                    CustomText(
                      text: "Tap here to select PDF",
                      size: FontSizes.lg,
                      weight: FontWeight.w500,
                    ),
                    CustomText(
                      text: "Max 10 MB",
                      color: AppColors.textSecondary,
                      size: FontSizes.md,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
