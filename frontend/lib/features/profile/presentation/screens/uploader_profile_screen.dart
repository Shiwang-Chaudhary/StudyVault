import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/helperFunc/date_time_format.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/models/notes_user_model.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/sub_tab.dart';
import 'package:study_vault/features/profile/presentation/widgets/uploader_notes_section.dart';

class UploaderProfileScreen extends ConsumerWidget {
  final NoteUserModel user;
  const UploaderProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> containerData = {
      "Downloads": user.totalDownloads,
      "Rating": user.avgRating,
      "Notes": user.totalNotes,
    };
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Profile",
          size: FontSizes.xxl,
          weight: FontWeight.w600,
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.border, width: 2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Profile Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.primaryMuted,
              child: CustomText(
                text: "SC",
                size: FontSizes.hero,
                color: AppColors.borderFocused,
              ),
            ),

            const SizedBox(height: 10),

            // Name
            CustomText(
              text: user.name,
              size: FontSizes.xxl,
              weight: FontWeight.w600,
            ),

            // University
            CustomText(
              text: "${user.college} | ${user.branch} | ${user.semester}",
              size: FontSizes.lg,
              weight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),

            // Joined Date
            CustomText(
              text: formatJoinedDate(user.createdAt),
              size: FontSizes.md,
              weight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                containerData.length,
                (index) => Expanded(
                  child: Container(
                    height: 76,
                    margin: const EdgeInsets.only(top: 10, left: 6, right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "${containerData.values.elementAt(index)}",
                          size: FontSizes.xxl,
                          color: AppColors.textPrimary,
                        ),
                        CustomText(
                          text: containerData.keys.elementAt(index),
                          size: FontSizes.md,
                          weight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Divider(color: AppColors.border, thickness: 1, height: 20),

            // // Notes heading + tabs
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const CustomText(
            //       text: "Notes by name",
            //       size: FontSizes.xxl,
            //       weight: FontWeight.w600,
            //     ),

            //     Row(
            //       children: [
            //         SubTab(isSelected: true, title: "Top rated"),
            //         SubTab(title: "Recent", isSelected: false),
            //       ],
            //     ),
            //   ],
            // ),

            // const SizedBox(height: 10),

            // // Notes
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 10,
            //     itemBuilder: (context, index) {
            //       return PdfContainer();
            //     },
            //   ),
            // ),
            Expanded(child: UploaderNotesSection(userId: user.id)),
          ],
        ),
      ),
    );
  }
}
