import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class NoteDownloadNotifier
    extends AsyncNotifier<({int downloadCount, String downloadUrl})?> {
  NotesRepository get _notesRepo => ref.read(notesRepositoryProvider);

  @override
  Future<({int downloadCount, String downloadUrl})?> build() async {
    return null;
  }

  Future<({int downloadCount, String downloadUrl})?> downloadNote(
    String noteId,
  ) async {
    try {
      state = const AsyncLoading();
      final result = await _notesRepo.downloadNote(noteId);
      // Store the result in the notifier state.
      state = AsyncData(result);

      return result;
    } catch (e, st) {
      log('Failed to download note', error: e, stackTrace: st);

      return null;
    }
  }
}

final noteDownloadProvider =
    AsyncNotifierProvider.autoDispose<
      NoteDownloadNotifier,
      ({int downloadCount, String downloadUrl})?
    >(NoteDownloadNotifier.new);
