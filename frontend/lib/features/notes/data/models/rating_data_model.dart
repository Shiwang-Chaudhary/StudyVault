import 'package:study_vault/features/notes/data/models/rating_model.dart';

class RatingData {
  final double avgRating;
  final int ratingCount;
  final List<Rating> ratings;
  final bool hasMore;
  final String? nextCursor;
  //NOT IN BACKEND RESPONSE:
  final bool isLoadingMore;

  RatingData({
    required this.avgRating,
    required this.ratingCount,
    required this.ratings,
    required this.hasMore,
    required this.isLoadingMore,
    this.nextCursor,
  });

  RatingData copyWith({
    double? avgRating,
    int? ratingCount,
    List<Rating>? ratings,
    bool? hasMore,
    String? nextCursor,
    bool? isLoadingMore,
  }) {
    return RatingData(
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      ratings: ratings ?? this.ratings,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      avgRating: (json['avgRating'] ?? 0).toDouble(),
      ratingCount: (json['ratingCount'] ?? 0).toInt(),
      ratings: (json['ratings'] as List<dynamic>? ?? [])
          .map((e) => Rating.fromJson(e))
          .toList(),
      hasMore: json['hasMore'] ?? false,
      nextCursor: json['nextCursor'],
      isLoadingMore: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avgRating': avgRating,
      'ratingCount': ratingCount,
      'ratings': ratings.map((e) => e.toJson()).toList(),
      'hasMore': hasMore,
      'nextCursor': nextCursor,
      'isLoadingMore': isLoadingMore,
    };
  }
}
