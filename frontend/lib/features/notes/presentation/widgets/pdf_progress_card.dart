import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_font_size.dart';

class PdfProgressCard extends StatelessWidget {
  final String title;
  final int currentPage;
  final int totalPages;

  const PdfProgressCard({
    super.key,
    required this.title,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    log("PdfProgressCard: currentPage: $currentPage, totalPages: $totalPages");
    final progress = totalPages == 0
        ? 0.0
        : (currentPage / totalPages).clamp(0.0, 1.0);

    final percentage = (progress * 100).round();

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF191C2F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFF34374D),
            ),
          ),

          const SizedBox(height: 10),

          // PDF title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: FontSizes.md,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          // Percentage
          Text(
            '$percentage% complete',
            style: const TextStyle(
              fontSize: FontSizes.sm,
              color: Color(0xFF9295A8),
            ),
          ),
        ],
      ),
    );
  }
}
