import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/data/user_model.dart';
import 'package:study_vault/features/auth/providers/auth_repo_provider.dart';

final userProfileProvider = FutureProvider<UserModel>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return authRepo.syncWithBackend();
});
