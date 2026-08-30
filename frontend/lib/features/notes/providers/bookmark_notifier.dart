import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

class BookmarkNotifier extends AsyncNotifier<List<Note>> {
  bool isPressed = false;
  NotesRepository get _notesRepo => ref.read(notesRepositoryProvider);
  @override
  Future<List<Note>> build() async {
    return _notesRepo.fetchBookmarks();
  }

  Future<void> fetchBookmark() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await _notesRepo.fetchBookmarks();
    });
  }

  Future<void> addBookmark(String noteId) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    isPressed = true;
    state = await AsyncValue.guard(() async {
      await _notesRepo.addBookmark(noteId);
      return await _notesRepo.fetchBookmarks();
    });
  }

  Future<void> deleteBookmark(String noteId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _notesRepo.deleteBookmark(noteId);
      return await _notesRepo.fetchBookmarks();
    });
  }
}

final bookmarkProvider =
    AsyncNotifierProvider.autoDispose<BookmarkNotifier, List<Note>>(
      () => BookmarkNotifier(),
    );
