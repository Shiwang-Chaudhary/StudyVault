import 'package:dio/dio.dart';
import 'package:study_vault/core/constans/api_constants.dart';
import 'package:study_vault/core/network/dio_provider.dart';
import 'package:study_vault/features/auth/data/auth_repository.dart';

class LoggedUserProfileRepo {
  final Dio dio;
  final AuthRepository auth;
  LoggedUserProfileRepo(this.dio, this.auth);

  Future<void> fetchUserNotes() async {
    try {
      final String? token = await auth.getIdToken;
      final response = await dio.get(
        ApiConstants.getUserNotes,
        queryParameters: {},
      );
    } catch (e) {}
  }
}
