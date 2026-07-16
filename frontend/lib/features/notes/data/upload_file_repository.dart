import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:study_vault/core/constans/api_constants.dart';
import 'package:study_vault/features/auth/data/auth_repository.dart';

class UploadFileRepository {
  final Dio dio;
  final AuthRepository authRepo;
  UploadFileRepository(this.dio, this.authRepo);

  Future<PlatformFile?> uploadFile({
    required String title,
    required String subject,
    required String college,
  }) async {
    final fileResult = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );
    if (fileResult == null) return null;
    final file = fileResult.files.first;
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
  }
}
