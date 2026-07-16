import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/core/network/dio_provider.dart';
import 'package:study_vault/features/auth/providers/auth_repo_provider.dart';
import 'package:study_vault/features/notes/data/upload_file_repository.dart';

final uploadFileProvider = Provider<UploadFileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return UploadFileRepository(dio, authRepo);
});
