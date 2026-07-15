import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/auth/data/onboarding_model.dart';

class OnboardingStateProvider extends Notifier<OnboardingModel> {
  @override
  OnboardingModel build() {
    return OnboardingModel(
      college: "",
      branch: "",
      semester: "",
      selectedSubjects: [],
    );
  }

  void update({
    String? college,
    String? branch,
    String? semester,
    List<String>? selectedSubjects,
  }) {
    state = state.copyWith(
      college: college,
      branch: branch,
      semester: semester,
      selectedSubjects: selectedSubjects,
    );
  }

  void toggleSubject(String subject) {
    final subjects = [...state.selectedSubjects];
    if (subjects.contains(subject)) {
      subjects.remove(subject);
    } else {
      subjects.add(subject);
    }
    state = state.copyWith(selectedSubjects: subjects);
  }
}

final onboardingStateProvider =
    NotifierProvider<OnboardingStateProvider, OnboardingModel>(
      () => OnboardingStateProvider(),
    );
