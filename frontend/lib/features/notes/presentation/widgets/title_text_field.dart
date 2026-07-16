import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';

class TitleTextField extends StatelessWidget {
  final TextEditingController controller;
  const TitleTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: FontSizes.lg),
      decoration: InputDecoration(
        hintText: "e.g. Operating Systems Unit 2",
        hintStyle: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: FontSizes.md,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
