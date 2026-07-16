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
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'subject': subject,
        'college': college,
        'pdf': await MultipartFile.fromFile(file.path!, filename: file.name),
      });
      final token = await authRepo.getIdToken;
      final response = await dio.post(
        ApiConstants.uploadFile,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      log("Response uploadFile: ${response.data}");
    } catch (e) {
      log("Error in uploadFile: $e");
      rethrow;
    }
  }
}
