import 'package:study_vault/features/notes/data/models/rating_model.dart';

class RatingData {
  final double avgRating;
  final int ratingCount;
  final List<Rating> ratings;
  final bool hasMore;
  final String? nextCursor;

  RatingData({
    required this.avgRating,
    required this.ratingCount,
    required this.ratings,
    required this.hasMore,
    this.nextCursor,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      avgRating: (json['avgRating'] ?? 0).toDouble(),
      ratingCount: (json['ratingCount'] ?? 0).toInt(),
      ratings: (json['ratings'] as List<dynamic>? ?? [])
          .map((e) => Rating.fromJson(e))
          .toList(),
      hasMore: json['hasMore'] ?? false,
      nextCursor: json['nextCursor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avgRating': avgRating,
      'ratingCount': ratingCount,
      'ratings': ratings.map((e) => e.toJson()).toList(),
      'hasMore': hasMore,
      'nextCursor': nextCursor,
    };
  }
}
