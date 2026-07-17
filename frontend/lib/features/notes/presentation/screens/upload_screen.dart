import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bounce/bounce.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/constans/college_branches.dart';
import 'package:study_vault/core/widgets/custom_auto_complete_text_field.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/auth/presentation/widgets/drop_down.dart';
import 'package:study_vault/features/notes/presentation/widgets/title_text_field.dart';
import 'package:study_vault/features/notes/presentation/widgets/upload_file_dotted_border.dart';
import 'package:study_vault/features/notes/providers/branch_semester_file_providers.dart';
import 'package:study_vault/features/notes/providers/progress_check_provider.dart';
import 'package:study_vault/features/notes/providers/upload_file_notifier.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  TextEditingController collegeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   ref.listenManual<AsyncValue<void>>(uploadFileNotifierProvider, (
  //     previous,
  //     next,
  //   ) {
  //     next.whenOrNull(
  //       data: (_) {
  //         debugPrint("Previous: ${previous.runtimeType} -> $previous");
  //         debugPrint("Next: ${next.runtimeType} -> $next");
  //         if (previous is AsyncLoading && next is AsyncData) {
  //           ScaffoldMessenger.of(
  //             context,
  //           ).showSnackBar(const SnackBar(content: Text("Upload successful")));
  //         }

  //         titleController.clear();
  //         collegeController.clear();
  //         subjectController.clear();

  //         ref.read(branchStateProvider.notifier).state = null;
  //         ref.read(semesterStateProvider.notifier).state = null;
  //         ref.read(selectedFileProvider.notifier).state = null;
  //       },
  //       error: (error, _) {
  //         ScaffoldMessenger.of(
  //           context,
  //         ).showSnackBar(SnackBar(content: Text(error.toString())));
  //       },
  //     );
  //   });
  // }

  @override
  void dispose() {
    titleController.dispose();
    collegeController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadFileNotifierProvider);
    final selectedBranch = ref.watch(branchStateProvider);
    final selectedSemester = ref.watch(semesterStateProvider);
    final selectedFile = ref.watch(selectedFileProvider);
    final progress = ref.watch(progressCheckProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: const CustomText(
              text: "Upload Screen",
              size: 24,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          UploadFileDottedBorder(
            selectedFileName: selectedFile?.name,
            onTap: () async {
              final result = await FilePicker.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );

              if (result == null) return;

              ref.read(selectedFileProvider.notifier).state =
                  result.files.first;
            },
          ),
          const SizedBox(height: 20),
          CustomText(
            text: "Title",
            color: const Color.fromARGB(255, 11, 12, 19),
            size: FontSizes.xl,
            weight: FontWeight.w500,
          ),
          const SizedBox(height: 5),
          TitleTextField(controller: titleController),
          const SizedBox(height: 20),
          CustomText(
            text: "College/University",
            color: AppColors.textSecondary,
            size: FontSizes.xl,
            weight: FontWeight.w500,
          ),
          const SizedBox(height: 5),
          CustomAutocompleteTextField(
            controller: collegeController,
            items: AppConstants.colleges,
            hintText: "e.g. ${AppConstants.colleges.first}",
            onSelected: (String college) {
              debugPrint('College: $college');
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Branch",
                      color: AppColors.textSecondary,
                      size: FontSizes.xl,
                      weight: FontWeight.w500,
                    ),
                    const SizedBox(height: 5),
                    DropDown(
                      value: selectedBranch,
                      onChanged: (value) {
                        ref.read(branchStateProvider.notifier).state = value;
                      },
                      items: AppConstants.branches,
                      hintText: AppConstants.branches.first,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Semester",
                      color: AppColors.textSecondary,
                      size: FontSizes.xl,
                      weight: FontWeight.w500,
                    ),
                    const SizedBox(height: 5),
                    DropDown(
                      value: selectedSemester,
                      onChanged: (value) {
                        ref.read(semesterStateProvider.notifier).state = value;
                      },
                      items: AppConstants.semesters,
                      hintText: AppConstants.semesters.first,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomText(
            text: "Subject",
            color: AppColors.textSecondary,
            size: FontSizes.xl,
            weight: FontWeight.w500,
          ),
          const SizedBox(height: 5),
          CustomAutocompleteTextField(
            controller: subjectController,
            items: AppConstants.mvpSubjectsByBranch['CSE']!,
            hintText: "e.g. ${AppConstants.mvpSubjectsByBranch['CSE']![1]}",
            onSelected: (String selection) {
              debugPrint('Selected: $selection');
            },
          ),
          const SizedBox(height: 20),
          Bounce(
            onTap: uploadState.isLoading
                ? null
                : () async {
                    if (selectedFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a PDF")),
                      );
                      return;
                    }
                    if (titleController.text.trim().isEmpty ||
                        subjectController.text.trim().isEmpty ||
                        collegeController.text.trim().isEmpty ||
                        selectedBranch == null ||
                        selectedSemester == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all the fields"),
                        ),
                      );
                      return;
                    }
                    try {
                      await ref
                          .read(uploadFileNotifierProvider.notifier)
                          .uploadFile(
                            title: titleController.text.trim(),
                            subject: subjectController.text.trim(),
                            college: collegeController.text.trim(),
                            branch: selectedBranch,
                            semester: selectedSemester,
                            file: selectedFile,
                          );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Upload successful")),
                      );

                      titleController.clear();
                      collegeController.clear();
                      subjectController.clear();

                      ref.read(branchStateProvider.notifier).state = null;
                      ref.read(semesterStateProvider.notifier).state = null;
                      ref.read(selectedFileProvider.notifier).state = null;
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  uploadState.isLoading
                      ? CircularProgressIndicator(
                          color: AppColors.textPrimary,
                          value: progress != null ? progress / 100 : null,
                        )
                      : Icon(
                          Iconsax.document_upload,
                          color: AppColors.textPrimary,
                          size: 28,
                        ),
                  const SizedBox(width: 10),
                  CustomText(
                    text: uploadState.isLoading
                        ? "${(progress ?? 0).toInt()}%"
                        : "Publish note",
                    size: FontSizes.xl,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
