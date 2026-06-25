import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class SubjectChip extends StatelessWidget {
  final String subject;
  final bool isSelected;
  final VoidCallback onTap;
  const SubjectChip({
    super.key,
    required this.subject,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected
                  ? Icon(Icons.check, color: AppColors.textPrimary, size: 20)
                  : SizedBox(),
              isSelected ? const SizedBox(width: 8) : const SizedBox.shrink(),
              CustomText(
                text: subject,
                size: FontSizes.xl,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
