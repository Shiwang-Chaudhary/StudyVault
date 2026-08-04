class NoteUserModel {
  final String id;
  final String name;
  final String photoUrl;
  final String college;
  final String branch;
  final String semester;
  final bool isVerified;

  const NoteUserModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.college,
    required this.branch,
    required this.semester,
    required this.isVerified,
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
  }) {
    return NoteUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      college: college ?? this.college,
      branch: branch ?? this.branch,
      semester: semester ?? this.semester,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
