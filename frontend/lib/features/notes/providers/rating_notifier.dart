import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/models/rating_data_model.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class RatingNotifier extends AsyncNotifier<RatingData> {
  NotesRepository get _notesRepo => ref.read(notesRepositoryProvider);
  @override
  Future<RatingData> build() async {
    return RatingData(
      avgRating: 0,
      ratingCount: 0,
      ratings: [],
      hasMore: false,
    );
  }

  Future<void> rateNote(String noteId, double rating) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _notesRepo.rateNote(noteId, rating);
      return await _notesRepo.fetchRatings(noteId);
    });
  }

  Future<void> fetchRatings(String noteId, [String? cursor]) async {
    log("FETCH RATINGS STARTED: $noteId");

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final data = await _notesRepo.fetchRatings(noteId, cursor);

      log("RATINGS RECEIVED: ${data.ratings.length}");
      log("AVG RATING: ${data.avgRating}");
      log("RATING COUNT: ${data.ratingCount}");

      for (final rating in data.ratings) {
        log("USER: ${rating.userName}, VALUE: ${rating.value}");
      }

      return data;
    });
  }
}

final ratingProvider =
    AsyncNotifierProvider.autoDispose<RatingNotifier, RatingData>(
      () => RatingNotifier(),
    );
