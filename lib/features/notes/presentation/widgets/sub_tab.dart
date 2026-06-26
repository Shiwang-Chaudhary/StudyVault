import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class SubTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  const SubTab({
    super.key,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          border: Border.all(color: AppColors.border, width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: CustomText(
            text: title,
            size: FontSizes.lg,
            weight: FontWeight.w600,
            overflow: TextOverflow.visible,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
