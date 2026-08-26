import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class NoteDownloadNotifier
    extends AsyncNotifier<({int downloadCount, File file})?> {
  NotesRepository get _notesRepo => ref.read(notesRepositoryProvider);

  @override
  Future<({int downloadCount, File file})?> build() async {
    return null;
  }

  Future<({int downloadCount, File file})?> downloadNote(String noteId) async {
    try {
      state = const AsyncLoading();
      final result = await _notesRepo.saveNoteToLocalStorage(noteId);
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
      ({int downloadCount, File file})?
    >(NoteDownloadNotifier.new);
