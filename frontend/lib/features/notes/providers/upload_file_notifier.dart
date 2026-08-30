import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/providers/user_profile_provider.dart';
import 'package:study_vault/features/notes/data/upload_file_repository.dart';
import 'package:study_vault/features/notes/providers/my_notes_notifier.dart';
import 'package:study_vault/features/notes/providers/progress_check_provider.dart';
import 'package:study_vault/features/notes/providers/upload_repo_provider.dart';

class UploadFileNotifier extends AsyncNotifier<void> {
  late final UploadFileRepository _uploadFileRepo;
  @override
  Future<void> build() async {
    _uploadFileRepo = ref.read(uploadFileProvider);
  }

  Future<void> uploadFile({
    required String title,
    required String subject,
    required String college,
    required String branch,
    required String semester,
    required PlatformFile file,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _uploadFileRepo.uploadFile(
        file: file,
        title: title,
        subject: subject,
        college: college,
        branch: branch,
        semester: semester,
        onProgress: (progress) {
          final progressPercentage = (progress * 100).toInt();
          ref.read(progressCheckProvider.notifier).state = progressPercentage;
        },
      );
    });
    ref.invalidate(userProfileProvider);
    ref.invalidate(myNotesNotifierProvider);
  }
}

final uploadFileNotifierProvider =
    AsyncNotifierProvider.autoDispose<UploadFileNotifier, void>(
      () => UploadFileNotifier(),
    );
