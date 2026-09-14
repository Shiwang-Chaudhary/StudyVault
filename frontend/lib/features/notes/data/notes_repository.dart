import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_vault/core/constans/api_constants.dart';
import 'package:study_vault/features/auth/data/auth_repository.dart';
import 'package:study_vault/features/notes/data/models/bookmark_backend_response_model.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';
import 'package:study_vault/features/notes/data/models/notes_response_model.dart';
import 'package:study_vault/features/notes/data/models/rating_data_model.dart';

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

  Future<({int downloadCount, File file})?> saveNoteToLocalStorage(
    String noteId,
  ) async {
    try {
      final result = await downloadNote(noteId);
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/note_$noteId.pdf");
      await dio.download(result.downloadUrl, file.path);
      return (downloadCount: result.downloadCount, file: file);
    } catch (e) {
      log("Error downloading file locally: $e");
      return null;
    }
  }

  Future<List<Note>> fetchBookmarks() async {
    try {
      final token = await auth.getIdToken;
      final response = await dio.get(
        ApiConstants.getBookmark,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      final responseData = response.data;
      final BookmarkResponse bookmarkResponse = BookmarkResponse.fromJson(
        responseData,
      );
      //using .where only because there is dummy data in the backend
      return bookmarkResponse.data
          .where((bookmark) => bookmark.note != null)
          .map((bookmark) => bookmark.note!)
          .toList();
    } catch (e) {
      log("Failed to load bookmarks: $e");
      throw Exception("Failed to load bookmarks. Please try again.");
    }
  }

  Future<void> addBookmark(String noteId) async {
    try {
      final token = await auth.getIdToken;
      final response = await dio.post(
        "/api/notes/$noteId/bookmark",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      log("Add bookmark response: ${response.data}");
    } catch (e) {
      log("Failed to add bookmark: $e");
      throw Exception("Faild to add bookmark: $e");
    }
  }

  Future<void> deleteBookmark(String noteId) async {
    try {
      final token = await auth.getIdToken;
      final response = await dio.delete(
        "/api/notes/$noteId/bookmark",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      log("Delete bookmark response: ${response.data}");
    } catch (e) {
      log("Failed to delete bookmark: $e");
      throw Exception("Faild to delete bookmark: $e");
    }
  }

  Future<void> rateNote(String noteId, double rating) async {
    try {
      final token = await auth.getIdToken;
      final response = await dio.post(
        ApiConstants.rateNote(noteId),
        data: {"value": rating},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      log("Rate note response: ${response.data}");
    } catch (e) {
      log("Failed to rate note: $e");
      throw Exception("Failed to rate note: $e");
    }
  }

  Future<RatingData> fetchRatings(String noteId, [String? nextCursor]) async {
    try {
      final token = await auth.getIdToken;
      final response = await dio.get(
        ApiConstants.fetchRatings(noteId),
        queryParameters: {if (nextCursor != null) "cursor": nextCursor},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      final data = RatingData.fromJson(response.data["data"]);
      // for (final rating in data.ratings) {
      //   log("Inside notesRepo:");
      //   log("USER: ${rating.userName}, VALUE: ${rating.value}");
      // }
      return data;
    } catch (e, stackTrace) {
      log("Failed to fetch ratings: $e");
      log("STACK TRACE:");
      log("$stackTrace");
      throw Exception("Failed to fetch ratings: $e");
    }
  }
}
