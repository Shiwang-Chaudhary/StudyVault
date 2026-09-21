import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';
import 'package:study_vault/features/notes/providers/notes_repo_provider.dart';

// Change the argument type from List<String> to String
final recommendedNotesProvider = FutureProvider.autoDispose
    .family<List<Note>, String>((ref, subjectsString) {
      final notesRepo = ref.watch(notesRepositoryProvider);

      // Convert the string back into a list
      final subjects = subjectsString.isEmpty
          ? <String>[]
          : subjectsString.split(',');

      return notesRepo.fetchRecommendedNotes(subjects);
    });
