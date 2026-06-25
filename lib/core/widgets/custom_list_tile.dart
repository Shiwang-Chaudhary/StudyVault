import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color leadingColor;
  final Color iconColor;
  final IconData icon;
  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.leadingColor = AppColors.primary,
    this.iconColor = Colors.white,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: CustomText(text: title, size: 16, weight: FontWeight.w600),
      subtitle: CustomText(
        text: subtitle,
        size: 14,
        weight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: leadingColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 30),
      ),
    );
  }
}
