import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/models/rating_model.dart';

class ReviewCard extends StatelessWidget {
  final Rating rating;

  const ReviewCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.10),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          CircleAvatar(
            radius: 23,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: CustomText(
              text: rating.userName.isNotEmpty
                  ? rating.userName[0].toUpperCase()
                  : "?",
              size: FontSizes.lg,
              weight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          // Review information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: rating.userName,
                  size: FontSizes.lg,
                  weight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),

                const SizedBox(height: 6),

                RatingBarIndicator(
                  rating: rating.value.toDouble(),
                  itemCount: 5,
                  itemSize: 19,
                  itemBuilder: (context, index) {
                    return Icon(Icons.star, color: AppColors.accentAmber);
                  },
                ),

                const SizedBox(height: 6),

                CustomText(
                  text: _formatDate(rating.createdAt),
                  size: FontSizes.sm,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      return date;
    }

    final localDate = parsedDate.toLocal();

    return "${localDate.day.toString().padLeft(2, '0')} "
        "${_monthName(localDate.month)} "
        "${localDate.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return months[month - 1];
  }
}
