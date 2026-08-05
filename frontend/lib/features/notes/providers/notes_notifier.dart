import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/data/notes_response_model.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class HomeNotesNotifier extends AsyncNotifier<NotesResponse> {
  String? _nextCursor;
  bool _hasMore = true;
  NotesRepository get _notesRepo => ref.read(notesRepositoryProvider);
  @override
  FutureOr<NotesResponse> build() async {
    final response = await _notesRepo.fetchNotes();
    _hasMore = response.hasMore;
    _nextCursor = response.nextCursor;
    return response;
  }

  Future<void> fetchFilteredNotes() async {}
}
