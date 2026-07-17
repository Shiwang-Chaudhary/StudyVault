class OnboardingModel {
  String college;
  String? branch;
  String? semester;
  List<String> selectedSubjects;

  OnboardingModel({
    required this.college,
    required this.branch,
    required this.semester,
    required this.selectedSubjects,
  });

  OnboardingModel copyWith({
    String? college,
    String? branch,
    String? semester,
    List<String>? selectedSubjects,
  }) {
    return OnboardingModel(
      branch: branch ?? this.branch,
      college: college ?? this.college,
      semester: semester ?? this.semester,
      selectedSubjects: selectedSubjects ?? this.selectedSubjects,
    );
  }
}
