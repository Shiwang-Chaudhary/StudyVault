import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:study_vault/core/constans/api_constants.dart';
import 'package:study_vault/features/auth/data/auth_repository.dart';
import 'package:study_vault/features/notes/data/notes_response_model.dart';

class NotesRepository {
  final Dio dio;
  final AuthRepository auth;
  NotesRepository(this.dio, this.auth);

  Future<NotesResponse> fetchUserNotes({String? nextCursor}) async {
    log("Fetch User notes called");
    final String? token = await auth.getIdToken;
    final response = await dio.get(
      ApiConstants.getUserNotes,
      queryParameters: {if (nextCursor != null) "cursor": nextCursor},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    NotesResponse notesResponse = NotesResponse.fromJson(response.data);
    log('''
      Fetched user notes:
      - Total Notes : ${notesResponse.totalNotes}
      - Fetched     : ${notesResponse.notes.length}
      - Has More    : ${notesResponse.hasMore}
      - Next Cursor : ${notesResponse.nextCursor}
      - Titles      : ${notesResponse.notes.map((e) => e.title).join(', ')}
    ''');
    return notesResponse;
  }
}
