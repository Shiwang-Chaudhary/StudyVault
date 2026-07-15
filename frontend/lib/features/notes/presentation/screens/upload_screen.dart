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

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  TextEditingController collegeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(16),
              dashPattern: [8, 4],
              color: AppColors.surfaceElevated,
              strokeWidth: 2,
            ),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 35,
                    color: AppColors.surfaceElevated,
                  ),
                  CustomText(
                    text: "Tap here to select PDF",
                    size: FontSizes.lg,
                    weight: FontWeight.w500,
                  ),
                  CustomText(
                    text: "Max 25 MB",
                    color: AppColors.textSecondary,
                    size: FontSizes.md,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomText(
            text: "Title",
            color: AppColors.textSecondary,
            size: FontSizes.xl,
            weight: FontWeight.w500,
          ),
          const SizedBox(height: 5),
          TitleTextField(controller: TextEditingController()),
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
                      onChanged: (value) {},
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
                      onChanged: (value) {},
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
            controller: TextEditingController(),
            items: AppConstants.mvpSubjectsByBranch['CSE']!,
            hintText: "e.g. ${AppConstants.mvpSubjectsByBranch['CSE']![1]}",
            onSelected: (String selection) {
              debugPrint('Selected: $selection');
            },
          ),
          const SizedBox(height: 20),
          Bounce(
            onTap: () {},
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
                  Icon(
                    Iconsax.document_upload,
                    color: AppColors.textPrimary,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  CustomText(
                    text: "Publish note",
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
