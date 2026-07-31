import 'package:study_vault/features/notes/data/notes_model.dart';

class NotesResponse {
  final List<Note> notes;
  final bool hasMore;
  final String? nextCursor;

  const NotesResponse({
    required this.notes,
    required this.hasMore,
    required this.nextCursor,
  });

  factory NotesResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return NotesResponse(
      notes: (data["notes"] as List).map((e) => Note.fromJson(e)).toList(),
      hasMore: data["hasMore"],
      nextCursor: data["nextCursor"],
    );
  }
}
