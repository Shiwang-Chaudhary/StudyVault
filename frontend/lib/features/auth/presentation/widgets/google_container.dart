import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class GoogleContainer extends StatelessWidget {
  final VoidCallback onTap;
  const GoogleContainer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Bounce(
        onTap: onTap,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/google.png'),
                height: 22,
                width: 22,
              ),
              SizedBox(width: 10),
              CustomText(
                text: 'Continue with Google',
                size: FontSizes.lg,
                weight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
