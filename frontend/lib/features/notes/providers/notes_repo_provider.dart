import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/core/network/dio_provider.dart';
import 'package:study_vault/features/auth/providers/auth_repo_provider.dart';
import 'package:study_vault/features/notes/data/notes_repository.dart';

final notesRepositoryProvider = Provider.autoDispose<NotesRepository>((ref) {
  final dio = ref.read(dioProvider);
  final authRepository = ref.read(authRepositoryProvider);
  return NotesRepository(dio, authRepository);
});
