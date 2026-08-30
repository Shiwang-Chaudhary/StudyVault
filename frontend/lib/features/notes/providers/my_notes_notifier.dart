import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/data/models/notes_response_model.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class MyNotesNotifier extends AsyncNotifier<NotesResponse> {
  String? _nextCursor;
  bool _hasMore = true;
  //Late final _notesRepo wasnt working (causing _notesRepo is already initialized)
  NotesRepository get _notesRepo => ref.read(notesRepositoryProvider);

  @override
  Future<NotesResponse> build() async {
    final response = await _notesRepo.fetchUserNotes();

    _nextCursor = response.nextCursor;
    _hasMore = response.hasMore;

    return response;
  }

  Future<void> fetchMoreNotes() async {
    final currentState = state.value;

    if (currentState == null) return;
    if (currentState.isLoadingMore) return;
    if (!_hasMore || _nextCursor == null) return;

    // Show bottom loader
    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final response = await _notesRepo.fetchUserNotes(nextCursor: _nextCursor);

      _nextCursor = response.nextCursor;
      _hasMore = response.hasMore;

      state = AsyncData(
        currentState.copyWith(
          notes: [...currentState.notes, ...response.notes],
          totalNotes: response.totalNotes,
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

  Future<void> refresh() async {
    _nextCursor = null;
    _hasMore = true;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await _notesRepo.fetchUserNotes();

      _nextCursor = response.nextCursor;
      _hasMore = response.hasMore;

      return response;
    });
  }
}

final myNotesNotifierProvider =
    AsyncNotifierProvider.autoDispose<MyNotesNotifier, NotesResponse>(
      MyNotesNotifier.new,
    );
