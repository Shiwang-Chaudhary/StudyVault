// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// import 'package:study_vault/core/config/app_colors.dart';
// import 'package:study_vault/core/config/app_font_size.dart';
// import 'package:study_vault/core/widgets/custom_text.dart';
// import 'package:study_vault/features/notes/data/models/rating_data_model.dart';
// import 'package:study_vault/features/notes/data/models/rating_model.dart';
// import 'package:study_vault/features/notes/presentation/widgets/review_card.dart';

// class AllReviewsScreen extends StatelessWidget {
//   final RatingData ratingData;

//   const AllReviewsScreen({super.key, required this.ratingData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,

//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         title: CustomText(
//           text: "Reviews",
//           size: FontSizes.xl,
//           weight: FontWeight.bold,
//           color: AppColors.textPrimary,
//         ),
//       ),

//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//             decoration: BoxDecoration(
//               color: AppColors.surface,
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(
//                 color: AppColors.textSecondary.withValues(alpha: 0.12),
//               ),
//             ),
//             child: Column(
//               children: [
//                 CustomText(
//                   text: ratingData.avgRating.toStringAsFixed(1),
//                   size: 40,
//                   weight: FontWeight.bold,
//                   color: AppColors.textPrimary,
//                 ),
//                 const SizedBox(height: 8),
//                 RatingBarIndicator(
//                   rating: ratingData.avgRating,
//                   itemCount: 5,
//                   itemSize: 28,
//                   itemBuilder: (context, index) {
//                     return Icon(Icons.star, color: AppColors.accentAmber);
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 CustomText(
//                   text:
//                       "${ratingData.ratingCount} "
//                       "${ratingData.ratingCount == 1 ? "review" : "reviews"}",
//                   size: FontSizes.md,
//                   color: AppColors.textSecondary,
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 28),
//           CustomText(
//             text: "All Reviews",
//             size: FontSizes.xxl,
//             weight: FontWeight.bold,
//             color: AppColors.textPrimary,
//           ),

//           const SizedBox(height: 14),
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: ratingData.ratings.length,
//               itemBuilder: (context, index) {
//                 final rating = ratingData.ratings[index];
//                 return ReviewCard(rating: rating);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/models/rating_data_model.dart';
import 'package:study_vault/features/notes/presentation/widgets/review_card.dart';
import 'package:study_vault/features/notes/providers/rating_notifier.dart';

class AllReviewsScreen extends ConsumerStatefulWidget {
  final String noteId;
  final RatingData ratingData;

  const AllReviewsScreen({
    super.key,
    required this.noteId,
    required this.ratingData,
  });

  @override
  ConsumerState<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends ConsumerState<AllReviewsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Fetch next page when user is close to the bottom
    if (position.pixels >= position.maxScrollExtent - 200) {
      final ratingState = ref.read(ratingProvider);

      ratingState.whenData((data) {
        if (data.hasMore && data.nextCursor != null) {
          ref
              .read(ratingProvider.notifier)
              .fetchRatings(widget.noteId, data.nextCursor);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratingState = ref.watch(ratingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: CustomText(
          text: "Reviews",
          size: FontSizes.xl,
          weight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),

      body: ratingState.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        error: (error, stackTrace) {
          return Center(
            child: CustomText(
              text: "Failed to load reviews",
              size: FontSizes.md,
              color: AppColors.textSecondary,
            ),
          );
        },

        data: (data) {
          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.textSecondary.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  children: [
                    CustomText(
                      text: data.avgRating.toStringAsFixed(1),
                      size: 40,
                      weight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),

                    const SizedBox(height: 8),

                    RatingBarIndicator(
                      rating: data.avgRating,
                      itemCount: 5,
                      itemSize: 28,
                      itemBuilder: (context, index) {
                        return Icon(Icons.star, color: AppColors.accentAmber);
                      },
                    ),

                    const SizedBox(height: 8),

                    CustomText(
                      text:
                          "${data.ratingCount} "
                          "${data.ratingCount == 1 ? "review" : "reviews"}",
                      size: FontSizes.md,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              CustomText(
                text: "All Reviews",
                size: FontSizes.xxl,
                weight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),

              const SizedBox(height: 14),

              ...data.ratings.map((rating) => ReviewCard(rating: rating)),

              if (data.hasMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
