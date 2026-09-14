import 'package:study_vault/features/notes/data/models/notes_model.dart';

class BookmarkResponse {
  final bool success;
  final List<Bookmark> data;
  final dynamic error;
  final Map<String, dynamic> meta;

  BookmarkResponse({
    required this.success,
    required this.data,
    required this.error,
    required this.meta,
  });

  factory BookmarkResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Bookmark.fromJson(item))
              .toList() ??
          [],
      error: json['error'],
      meta: Map<String, dynamic>.from(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'error': error,
      'meta': meta,
    };
  }
}

class Bookmark {
  final String id;
  final String loggedInUserId;
  final Note note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Bookmark({
    required this.id,
    required this.loggedInUserId,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['_id'] ?? '',
      loggedInUserId: json['user'] ?? '',
      note: Note.fromJson(json['note']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': loggedInUserId,
      'note': note.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}
