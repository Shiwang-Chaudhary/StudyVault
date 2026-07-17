import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:study_vault/core/constans/api_constants.dart';
import 'package:study_vault/features/auth/data/auth_repository.dart';

class UploadFileRepository {
  final Dio dio;
  final AuthRepository authRepo;
  UploadFileRepository(this.dio, this.authRepo);

  Future<void> uploadFile({
    required String title,
    required String subject,
    required String college,
    required PlatformFile file,
    required String branch,
    required String semester,
    required void onProgress(double progress),
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'subject': subject,
        'college': college,
        'branch': branch,
        'semester': semester,
        'pdf': await MultipartFile.fromFile(file.path!, filename: file.name),
      });
      final token = await authRepo.getIdToken;
      final response = await dio.post(
        ApiConstants.uploadFile,
        data: formData,
        options: Options(
          sendTimeout: const Duration(minutes: 5),
          receiveTimeout: const Duration(minutes: 5),
          headers: {"Authorization": "Bearer $token"},
        ),
        onSendProgress: (sent, total) {
          onProgress(sent / total);
          final progress = (sent / total * 100).toStringAsFixed(0);
          log("Uploading: $progress%");
        },
      );
      log("Response uploadFile: ${response.data}");
    } catch (e) {
      log("Error in uploadFile: $e");
      rethrow;
    }
  }
}
