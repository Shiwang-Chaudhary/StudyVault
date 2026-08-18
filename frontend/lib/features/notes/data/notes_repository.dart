import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<NotesResponse> fetchNotes({
    String? nextCursor,
    String? subject,
    String? college,
    String? branch,
    String? semester,
    String? search,
    String? sort,
    String? userId,
  }) async {
    final String? token = await auth.getIdToken;
    final response = await dio.get(
      ApiConstants.getFilteredNotes,
      options: Options(headers: {"Authorization": "Bearer $token"}),
      queryParameters: {
        if (nextCursor != null) 'cursor': nextCursor,
        if (subject != null) 'subject': subject,
        if (college != null) 'college': college,
        if (branch != null) 'branch': branch,
        if (semester != null) 'semester': semester,
        if (search != null) 'search': search,
        if (sort != null) 'sort': sort,
        if (userId != null) 'userId': userId,
      },
    );
    return NotesResponse.fromJson(response.data);
  }

  Future<({String downloadUrl, int downloadCount})> downloadNote(
    String noteId,
  ) async {
    final token = await auth.getIdToken;
    final response = await dio.get(
      "/api/notes/$noteId/download",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    final data = response.data["data"];
    return (
      downloadUrl: data["downloadUrl"] as String,
      downloadCount: data["downloadCount"] as int,
    );
  }

  Future<File?> saveNoteToLocalStorage(String noteId) async {
    try {
      final result = await downloadNote(noteId);
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/note_$noteId.pdf");
      await dio.download(result.downloadUrl, file);
      return file;
    } catch (e) {
      log("Error downloading file locally: $e");
      return null;
    }
  }
}
