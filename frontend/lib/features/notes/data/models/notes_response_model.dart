import 'package:study_vault/features/notes/data/models/notes_model.dart';

class NotesResponse {
  final List<Note> notes;
  final int? totalNotes;
  final bool hasMore;
  final String? nextCursor;
  //NOT IN BACKEND RESPONSE (isLoadingMore)
  final bool isLoadingMore;

  const NotesResponse({
    required this.notes,
    this.totalNotes,
    required this.hasMore,
    required this.nextCursor,
    required this.isLoadingMore,
  });

  factory NotesResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return NotesResponse(
      notes: (data["notes"] as List).map((e) => Note.fromJson(e)).toList(),
      totalNotes: data["totalNotes"],
      hasMore: data["hasMore"],
      nextCursor: data["nextCursor"],
      isLoadingMore: false,
    );
  }

  NotesResponse copyWith({
    List<Note>? notes,
    int? totalNotes,
    bool? hasMore,
    String? nextCursor,
    bool? isLoadingMore,
  }) {
    return NotesResponse(
      notes: notes ?? this.notes,
      totalNotes: totalNotes ?? this.totalNotes,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
