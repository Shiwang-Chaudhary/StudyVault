import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/constans/college_branches.dart';
import 'package:study_vault/core/widgets/custom_auto_complete_text_field.dart';
import 'package:study_vault/core/widgets/custom_button.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/core/widgets/custom_text_field.dart';
import 'package:study_vault/features/auth/data/onboarding_model.dart';
import 'package:study_vault/features/auth/presentation/widgets/disclaimer.dart';
import 'package:study_vault/features/auth/presentation/widgets/drop_down.dart';
import 'package:study_vault/features/auth/presentation/widgets/subject_chip.dart';
import 'package:study_vault/features/auth/providers/onboarding_submit_provider.dart';
import 'package:study_vault/features/auth/providers/onboarding_state_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController pageController = PageController();
  bool isSelected = false;
  final TextEditingController collegeController = TextEditingController();
  @override
  void dispose() {
    pageController.dispose();
    collegeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingData = ref.watch(onboardingStateProvider);
    final onboardingNotifier = ref.read(onboardingSubmitProvider.notifier);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            tellUsAboutYou(
              pageController,
              collegeController: collegeController,
              onboardingData: onboardingData,
              ref: ref,
              context: context,
            ),
            whatAreYouHereFor(ref, onboardingData),
          ],
        ),
      ),
    );
  }
}

Widget tellUsAboutYou(
  PageController pageController, {
  required TextEditingController collegeController,
  required OnboardingModel onboardingData,
  required WidgetRef ref,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: AppColors.infoMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.person, color: AppColors.info, size: 45),
        ),
        const SizedBox(height: 10),
        CustomText(
          text: "Tell us about you",
          size: FontSizes.display,
          weight: FontWeight.w600,
        ),
        const SizedBox(height: 5),
        CustomText(
          text:
              "This helps us show you notes relevant to your college and branch",
          size: FontSizes.lg,
          color: AppColors.textSecondary,
          maxLines: 2,
          weight: FontWeight.w600,
        ),
        const SizedBox(height: 30),
        CustomText(
          text: "College",
          size: FontSizes.lg,
          color: AppColors.textSecondary,
          maxLines: 2,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: 10),
        // CustomTextField(
        //   hintText: "Search your college",
        //   controller: collegeController,
        // ),
        CustomAutocompleteTextField(
          controller: collegeController,
          items: AppConstants.colleges,
          hintText: "e.g. ${AppConstants.colleges.first}",
          onSelected: (String college) {
            debugPrint('College: $college');
            ref.read(onboardingStateProvider.notifier).update(college: college);
          },
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: DropDown(
                hintText: "Branch",
                // header: "Branch",
                items: AppConstants.branches,
                onChanged: (String? branchValue) {
                  debugPrint('Branch: $branchValue');
                  ref
                      .read(onboardingStateProvider.notifier)
                      .update(branch: branchValue);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropDown(
                hintText: "Semester",
                items: AppConstants.semesters,
                onChanged: (String? semesterValue) {
                  debugPrint('Semester: $semesterValue');
                  ref
                      .read(onboardingStateProvider.notifier)
                      .update(semester: semesterValue);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Disclaimer(),
        const SizedBox(height: 80),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            text: "Continue",
            onPressed: () {
              if (collegeController.text.trim().isEmpty ||
                  onboardingData.branch == null ||
                  onboardingData.semester == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill in all the fields"),
                  ),
                );
                return;
              }
              ref
                  .read(onboardingStateProvider.notifier)
                  .update(college: collegeController.text.trim());
              pageController.nextPage(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              );
            },
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget whatAreYouHereFor(WidgetRef ref, OnboardingModel onboardingData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 100),
      Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: AppColors.accentTealMuted,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.bookmark_add_outlined,
          color: AppColors.accentTeal,
          size: 36,
        ),
      ),
      const SizedBox(height: 10),
      CustomText(
        text: "What are you here for?",
        size: FontSizes.display,
        weight: FontWeight.w600,
      ),
      const SizedBox(height: 10),
      CustomText(
        text: "Pick a few subjects you want notes for. We'll show these first.",
        size: FontSizes.lg,
        weight: FontWeight.w600,
        maxLines: 2,
        color: AppColors.textSecondary,
      ),
      const SizedBox(height: 20),
      Wrap(
        spacing: 12,
        runSpacing: 12,

        children:
            (AppConstants.mvpSubjectsByBranch[onboardingData.branch] ??
                    AppConstants.mvpSubjectsByBranch["CSE"]!)
                .map(
                  (subject) => SubjectChip(
                    subject: subject,
                    isSelected: onboardingData.selectedSubjects.contains(
                      subject,
                    ),
                    onTap: () {
                      ref
                          .read(onboardingStateProvider.notifier)
                          .toggleSubject(subject);
                    },
                  ),
                )
                .toList(),
      ),
      const SizedBox(height: 60),
      CustomButton(
        text: "Done",
        onPressed: () {
          ref
              .read(onboardingSubmitProvider.notifier)
              .submitOnboarding(onboardingData);
        },
        width: double.infinity,
        height: 55,
      ),
    ],
  );
}
