import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/upload_file_repository.dart';
import 'package:study_vault/features/notes/providers/upload_repo_provider.dart';

class UploadFileNotifier extends AsyncNotifier<void> {
  late final UploadFileRepository uploadFileRepo;
  @override
  Future<void> build() async {
    uploadFileRepo = ref.read(uploadFileProvider);
  }

  Future<void> uploadFile({
    required String title,
    required String subject,
    required String college,
  }) async {
    final fileResult = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );
    if (fileResult == null) return;
    final file = fileResult.files.first;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await uploadFileRepo.uploadFile(
        file: file,
        title: title,
        subject: subject,
        college: college,
      );
    });
  }
}

final uploadFileNotifierProvider =
    AsyncNotifierProvider<UploadFileNotifier, void>(() => UploadFileNotifier());
