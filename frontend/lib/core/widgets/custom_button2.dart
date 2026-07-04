import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double width;
  const CustomButton2({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.textPrimary,
    this.height = 60,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: CustomText(
            text: text,
            size: FontSizes.xl,
            weight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
