import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: FontSizes.xl,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textTertiary,
          size: 28,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 60,
          minHeight: 48,
        ),
      ),
    );
  }
}
