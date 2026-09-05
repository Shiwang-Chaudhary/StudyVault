class Rating {
  final String id;
  final String userId;
  final String userName;
  final String note;
  final double value;
  final String createdAt;
  final String updatedAt;

  Rating({
    required this.id,
    required this.userId,
    required this.userName,
    required this.note,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'] ?? '',
      userId: json['user']?['_id'] ?? '',
      userName: json['user']?['name'] ?? '',
      note: json['note'] ?? '',
      value: (json['value'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {'_id': userId, 'name': userName},
      'note': note,
      'value': value,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
