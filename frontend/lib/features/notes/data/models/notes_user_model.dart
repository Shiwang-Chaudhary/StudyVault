class NoteUserModel {
  final String id;
  final String name;
  final String photoUrl;
  final String college;
  final String branch;
  final String semester;
  final bool isVerified;
  final int totalNotes;
  final int totalBookmarks;
  final double avgRating;
  final String createdAt; // Added createdAt field
  final String updatedAt; // Added updatedAt field

  const NoteUserModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.college,
    required this.branch,
    required this.semester,
    required this.isVerified,
    required this.totalNotes,
    required this.createdAt, // Initialize createdAt
    required this.updatedAt, // Initialize updatedAt
    this.totalBookmarks = 0, // Default value for totalBookmarks
    this.avgRating = 0.0, // Default value for avgRating
  });

  factory NoteUserModel.fromJson(Map<String, dynamic> json) {
    return NoteUserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
      college: json['college'] as String,
      branch: json['branch'] as String,
      semester: json['semester'] as String,
      isVerified: json['isVerified'] as bool,
      totalNotes: json['totalNotes'] as int,
      createdAt: json['createdAt'] as String, // Parse createdAt
      updatedAt: json['updatedAt'] as String, // Parse updatedAt
      totalBookmarks: json['totalBookmarks'] as int? ?? 0, // Handle null
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'photoUrl': photoUrl,
      'college': college,
      'branch': branch,
      'semester': semester,
      'isVerified': isVerified,
      'totalNotes': totalNotes,
      'createdAt': createdAt, // Include createdAt in JSON
      'updatedAt': updatedAt, // Include updatedAt in JSON
      'totalBookmarks': totalBookmarks, // Include totalBookmarks in JSON
      'avgRating': avgRating, // Include avgRating in JSON
    };
  }

  NoteUserModel copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? college,
    String? branch,
    String? semester,
    bool? isVerified,
    int? totalNotes,
    int? totalBookmarks,
    double? avgRating,
    String? createdAt, // Optional parameter for createdAt
    String? updatedAt, // Optional parameter for updatedAt
  }) {
    return NoteUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      college: college ?? this.college,
      branch: branch ?? this.branch,
      semester: semester ?? this.semester,
      isVerified: isVerified ?? this.isVerified,
      totalNotes: totalNotes ?? this.totalNotes,
      createdAt: createdAt ?? this.createdAt, // Preserve createdAt
      updatedAt: updatedAt ?? this.updatedAt, // Preserve updatedAt
      totalBookmarks: totalBookmarks ?? this.totalBookmarks,
      avgRating: avgRating ?? this.avgRating,
    );
  }
}
