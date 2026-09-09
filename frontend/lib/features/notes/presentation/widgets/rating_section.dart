import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/presentation/widgets/see_all_reviews.dart';
import 'package:study_vault/features/notes/providers/current_user_id_provider.dart';
import 'package:study_vault/features/notes/providers/rating_notifier.dart';
import 'package:study_vault/features/notes/providers/select_rating_provider.dart';

class RatingSection extends ConsumerStatefulWidget {
  final String noteId;
  const RatingSection({super.key, required this.noteId});

  @override
  ConsumerState<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends ConsumerState<RatingSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ratingProvider(widget.noteId).notifier).fetchMoreRatings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rating = ref.watch(ratingProvider(widget.noteId));
    final selectedRating = ref.watch(selectRatingProvider);
    return rating.when(
      error: (error, stackTrace) {
        log("Error fetching rating data: $error");
        return Scaffold(
          body: Center(
            child: CustomText(
              text: "Error fetching rating data",
              color: AppColors.error,
              size: FontSizes.lg,
            ),
          ),
        );
      },
      loading: () {
        log("Loading rating data...");
        return Scaffold(
          body: Center(
            child: CustomText(
              text: "Loading rating data...",
              color: AppColors.textSecondary,
              size: FontSizes.lg,
            ),
          ),
        );
      },
      data: (ratingData) {
        final hasAlreadyRated = ratingData.ratings.any(
          (e) => e.userId == ref.read(currentUserIdProvider),
        );
        return Column(
          children: [
            SizedBox(height: 10),
            hasAlreadyRated
                ? CustomText(text: "You already rated this note, Rate again?")
                : CustomText(
                    text: "Rate this note",
                    size: FontSizes.xxl,
                    weight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            Row(
              children: [
                RatingBar.builder(
                  glow: true,
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star_outline_rounded, color: Colors.amber),
                  onRatingUpdate: (rating) async {
                    log("rating: $rating");
                    ref.read(selectRatingProvider.notifier).state = rating;
                  },
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    if (selectedRating == 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: CustomText(
                            text: "Please select a rating before submitting.",
                            color: AppColors.error,
                            size: FontSizes.md,
                          ),
                          backgroundColor: AppColors.background,
                        ),
                      );
                      return;
                    }
                    log("Selected rating: $selectedRating");
                    ref
                        .read(ratingProvider(widget.noteId).notifier)
                        .rateNote(selectedRating);
                  },
                  child: CustomText(
                    text: "Submit",
                    color: AppColors.primary,
                    size: FontSizes.lg,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Reviews",
                  size: FontSizes.xxl,
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AllReviewsScreen(
                          noteId: widget.noteId,
                          ratingData: ratingData,
                        ),
                      ),
                    );
                  },
                  child: CustomText(
                    text: "See all",
                    color: AppColors.primary,
                    size: FontSizes.md,
                  ),
                ),
              ],
            ),
            Column(
              children: List.generate(
                ratingData.ratings.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: ratingData.ratings[index].userName,
                        size: FontSizes.lg,
                        color: AppColors.textPrimary,
                      ),

                      Row(
                        children: List.generate(
                          ratingData.ratings[index].value.toInt(),
                          (i) => Icon(
                            Icons.star,
                            color: AppColors.accentAmber,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
