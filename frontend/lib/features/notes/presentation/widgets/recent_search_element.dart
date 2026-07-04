import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';

class RecentSearchElement extends StatelessWidget {
  final String searchText;
  final VoidCallback? onTap;

  const RecentSearchElement({super.key, required this.searchText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(Icons.history, size: 23, color: Colors.grey[600]),
            const SizedBox(width: 20),
            CustomText(
              text: searchText,
              size: FontSizes.xl,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
