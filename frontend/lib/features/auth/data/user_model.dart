// Mirrors the MongoDB User document returned by POST /auth/sync
// and PATCH /auth/onboarding.
// Flutter uses this to decide routing after sign-in.

class UserModel {
  final String id;
  final String firebaseUid;
  final String name;
  final String email;
  final String? photoUrl;

  // Onboarding fields — null until OnboardingScreen is completed
  // This is the single flag that drives post-login routing:
  // college == null → OnboardingScreen, else → MainScreen
  final String? college;
  final String? branch;
  final String? semester;
  final List<String> interests;

  // Stats
  final int totalNotes;
  final int totalDownloads;
  final double avgRating;
  final bool isVerified;

  // V2 — stored now, used later
  final double walletBalance;
  final double earnings;

  const UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.college,
    this.branch,
    this.semester,
    this.interests = const [],
    this.totalNotes = 0,
    this.totalDownloads = 0,
    this.avgRating = 0.0,
    this.isVerified = false,
    this.walletBalance = 0,
    this.earnings = 0,
  });

  /// True once the user has completed OnboardingScreen step 1.
  /// This drives post-login routing in AuthGate.
  bool get hasCompletedOnboarding => college != null && branch != null;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      firebaseUid: json['firebaseUid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      college: json['college'],
      branch: json['branch'],
      semester: json['semester'],
      interests: List<String>.from(json['interests'] ?? []),
      totalNotes: json['totalNotes'] ?? 0,
      totalDownloads: json['totalDownloads'] ?? 0,
      avgRating: (json['avgRating'] ?? 0).toDouble(),
      isVerified: json['isVerified'] ?? false,
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      earnings: (json['earnings'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firebaseUid': firebaseUid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'college': college,
      'branch': branch,
      'semester': semester,
      'interests': interests,
      'totalNotes': totalNotes,
      'totalDownloads': totalDownloads,
      'avgRating': avgRating,
      'isVerified': isVerified,
      'walletBalance': walletBalance,
      'earnings': earnings,
    };
  }
}
