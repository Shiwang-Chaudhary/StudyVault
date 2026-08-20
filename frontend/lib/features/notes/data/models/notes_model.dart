import 'package:study_vault/features/notes/data/models/notes_user_model.dart';

class Note {
  final String id;
  final NoteUserModel user;
  final String title;
  final String description;
  final String subject;
  final String branch;
  final String semester;
  final String college;
  final int pageCount;
  final String cloudinaryUrl;
  final String cloudinaryPublicId;
  final int likeCount;
  final int downloadCount;
  final double avgRating;
  final int ratingCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    required this.subject,
    required this.branch,
    required this.semester,
    required this.college,
    required this.pageCount,
    required this.cloudinaryUrl,
    required this.cloudinaryPublicId,
    required this.likeCount,
    required this.downloadCount,
    required this.avgRating,
    required this.ratingCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["_id"],
      user: NoteUserModel.fromJson(json["userId"]),
      title: json["title"],
      description: json["description"] ?? "",
      subject: json["subject"],
      branch: json["branch"],
      semester: json["semester"],
      college: json["college"],
      pageCount: json["pageCount"],
      cloudinaryUrl: json["cloudinaryUrl"],
      cloudinaryPublicId: json["cloudinaryPublicId"],
      likeCount: json["likeCount"] ?? 0,
      downloadCount: json["downloadCount"] ?? 0,
      avgRating: (json["avgRating"] as num?)?.toDouble() ?? 0.0,
      ratingCount: json["ratingCount"] ?? 0,
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": user.toJson(),
      "title": title,
      "description": description,
      "subject": subject,
      "branch": branch,
      "semester": semester,
      "college": college,
      "pageCount": pageCount,
      "cloudinaryUrl": cloudinaryUrl,
      "cloudinaryPublicId": cloudinaryPublicId,
      "likeCount": likeCount,
      "downloadCount": downloadCount,
      "avgRating": avgRating,
      "ratingCount": ratingCount,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  Note copyWith({
    String? id,
    NoteUserModel? user,
    String? title,
    String? description,
    String? subject,
    String? branch,
    String? semester,
    String? college,
    int? pageCount,
    String? cloudinaryUrl,
    String? cloudinaryPublicId,
    int? likeCount,
    int? downloadCount,
    double? avgRating,
    int? ratingCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      branch: branch ?? this.branch,
      semester: semester ?? this.semester,
      college: college ?? this.college,
      pageCount: pageCount ?? this.pageCount,
      cloudinaryUrl: cloudinaryUrl ?? this.cloudinaryUrl,
      cloudinaryPublicId: cloudinaryPublicId ?? this.cloudinaryPublicId,
      likeCount: likeCount ?? this.likeCount,
      downloadCount: downloadCount ?? this.downloadCount,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
