import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/models/rating_data_model.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class RatingNotifier extends AsyncNotifier<RatingData> {
  bool _hasMore = false;
  String? _nextCursor;
  NotesRepository get _notesRepo => ref.read(notesRepositoryProvider);
  RatingNotifier(this.noteId);
  final String noteId;
  @override
  Future<RatingData> build() async {
    final response = await _notesRepo.fetchRatings(noteId);
    _hasMore = response.hasMore;
    _nextCursor = response.nextCursor;
    return response;
  }

  Future<void> rateNote(double rating) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _notesRepo.rateNote(noteId, rating);
      return await _notesRepo.fetchRatings(noteId);
    });
  }

  Future<void> fetchMoreRatings() async {
    final currentState = state.value;
    if (currentState == null) return;
    if (currentState.isLoadingMore) return;
    if (!_hasMore || _nextCursor == null) return;
    state = AsyncData(currentState.copyWith(isLoadingMore: true));
    try {
      final response = await _notesRepo.fetchRatings(noteId, _nextCursor);
      _hasMore = response.hasMore;
      _nextCursor = response.nextCursor;
      state = AsyncData(
        currentState.copyWith(
          ratings: [...currentState.ratings, ...response.ratings],
          hasMore: response.hasMore,
          nextCursor: response.nextCursor,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      log("Failed to load more notes", error: e, stackTrace: st);

      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }
}

final ratingProvider = AsyncNotifierProvider.autoDispose
    .family<RatingNotifier, RatingData, String>(RatingNotifier.new);
