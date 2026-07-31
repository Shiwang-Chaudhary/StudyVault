import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/data/notes_response_model.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class MyNotesNotifier extends AsyncNotifier<NotesResponse> {
  String? _nextCursor;
  bool _hasMore = true;
  late final NotesRepository _notesRepo;
  @override
  Future<NotesResponse> build() async {
    _notesRepo = await ref.read(notesRepositoryProvider);
    final response = await _notesRepo.fetchUserNotes();
    _nextCursor = response.nextCursor;
    _hasMore = response.hasMore;
    return response;
  }

  Future<void> fetchMoreNotes() async {
    try {
      if (!_hasMore || _nextCursor == null) return;
      final currentState = state.value;
      if (currentState == null) return;
      //Fetch new data
      final response = await _notesRepo.fetchUserNotes(nextCursor: _nextCursor);
      //Replace old nextcursor and hasmore with new
      _nextCursor = response.nextCursor;
      _hasMore = response.hasMore;

      state = AsyncData(
        NotesResponse(
          notes: [...currentState.notes, ...response.notes],
          hasMore: response.hasMore,
          nextCursor: response.nextCursor,
        ),
      );
    } catch (e) {
      log("Failed to load more notes: $e");
    }
  }

  Future<void> refresh() async {
    //We do nextCursor = null because we load the data from the start
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
