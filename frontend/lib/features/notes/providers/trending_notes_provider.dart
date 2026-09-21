import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

final trendingNotesProvider = FutureProvider.autoDispose<List<Note>>((ref) {
  final notesRepo = ref.watch(notesRepositoryProvider);
  return notesRepo.fetchTrendingNotes();
});
