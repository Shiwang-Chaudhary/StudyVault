import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/notes_query_params.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/data/notes_response_model.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class FilteredNotesNotifier extends AsyncNotifier<NotesResponse> {
  String? _nextCursor;
  bool _hasMore = true;
  final NotesQueryParams params;
  FilteredNotesNotifier(this.params);
  NotesRepository get _notesRepo => ref.read(notesRepositoryProvider);

  @override
  Future<NotesResponse> build() async {
    final response = await _notesRepo.fetchNotes(
      branch: params.branch,
      college: params.college,
      search: params.search,
      semester: params.semester,
      sort: params.sort,
      subject: params.subject,
      userId: params.userId,
    );
    _hasMore = response.hasMore;
    _nextCursor = response.nextCursor;

    return response;
  }

  Future<void> fetchMoreNotes() async {
    log("Fetch more notes called...........................................");
    final currentState = state.value;
    if (currentState == null) return;
    if (currentState.isLoadingMore) return;
    if (!_hasMore || _nextCursor == null) return;
    try {
      state = AsyncData(currentState.copyWith(isLoadingMore: true));
      final response = await _notesRepo.fetchNotes(
        branch: params.branch,
        college: params.college,
        nextCursor: _nextCursor,
        search: params.search,
        semester: params.semester,
        sort: params.sort,
        subject: params.subject,
        userId: params.userId,
      );
      _nextCursor = response.nextCursor;
      _hasMore = response.hasMore;

      state = AsyncData(
        currentState.copyWith(
          hasMore: _hasMore,
          isLoadingMore: false,
          nextCursor: _nextCursor,
          totalNotes: response.totalNotes,
          notes: [...currentState.notes, ...response.notes],
        ),
      );
    } catch (e, st) {
      log("Failed to load more filtered notes", error: e, stackTrace: st);
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }
}

final filteredNotesProvider = AsyncNotifierProvider.autoDispose
    .family<FilteredNotesNotifier, NotesResponse, NotesQueryParams>(
      FilteredNotesNotifier.new,
    );
