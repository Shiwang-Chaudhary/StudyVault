import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/core/widgets/custom_text_field.dart';
import 'package:study_vault/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/home_screen_tab_bar.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Good Evening!",
                      color: AppColors.textSecondary,
                      size: FontSizes.xl,
                      weight: FontWeight.w600,
                    ),
                    CustomText(
                      text: "Shiwang Chaudhary",
                      color: AppColors.textPrimary,
                      size: FontSizes.display,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.infoMuted,
                  child: CustomText(
                    text: "SC",
                    color: AppColors.info,
                    size: FontSizes.xl,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: "Search notes",
              controller: TextEditingController(),
            ),
            const SizedBox(height: 20),
            const HomeScreenTabBar(),
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 120,
                    width: 180,
                    decoration: BoxDecoration(
                      color: AppColors.primaryMuted,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Spacer(),
                          Icon(
                            Icons.bookmark,
                            color: AppColors.primaryPressed,
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          CustomText(
                            text: "Saved",
                            color: AppColors.borderFocused,
                            size: FontSizes.lg,
                            weight: FontWeight.w600,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 120,
                    width: 180,
                    decoration: BoxDecoration(
                      color: AppColors.accentTealMuted,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Spacer(),
                          Icon(Icons.download, color: Colors.teal, size: 40),
                          SizedBox(height: 5),
                          CustomText(
                            text: "Downloads",
                            color: Colors.teal,
                            size: FontSizes.lg,
                            weight: FontWeight.w600,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Recently opened",
                  size: FontSizes.xl,
                  weight: FontWeight.w600,
                ),
                CustomText(
                  text: "See All",
                  size: FontSizes.md,
                  weight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(
                2,
                (_) => Bounce(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NoteDetailScreen(),
                      ),
                    );
                  },
                  child: const PdfContainer(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Trending",
                  size: FontSizes.xl,
                  weight: FontWeight.w600,
                  // color: AppColors.info,
                ),
                CustomText(
                  text: "See All",
                  size: FontSizes.md,
                  weight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(
                3,
                (_) => Bounce(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NoteDetailScreen(),
                      ),
                    );
                  },
                  child: const PdfContainer(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Recommended for you",
                  size: FontSizes.xl,
                  weight: FontWeight.w600,
                ),
                CustomText(
                  text: "See All",
                  size: FontSizes.md,
                  weight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(
                3,
                (_) => Bounce(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NoteDetailScreen(),
                      ),
                    );
                  },
                  child: const PdfContainer(),
                ),
              ),
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   padding: const EdgeInsets.only(top: 10),
            //   itemCount: AppConstants.mvpSubjectsByBranch["CSE"]!.length,
            //   scrollDirection: Axis.vertical,
            //   itemBuilder: (context, index) {
            //     return Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             CustomText(
            //               text: AppConstants.mvpSubjectsByBranch["CSE"]![index],
            //               size: FontSizes.xxl,
            //               weight: FontWeight.w600,
            //             ),
            //             CustomText(
            //               text: "See All",
            //               size: FontSizes.lg,
            //               weight: FontWeight.w600,
            //               color: AppColors.primary,
            //             ),
            //           ],
            //         ),
            //         const SizedBox(height: 10),
            //         Column(
            //           children: List.generate(
            //             3,
            //             (_) => Bounce(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => const NoteDetailScreen(),
            //                   ),
            //                 );
            //               },
            //               child: const PdfContainer(),
            //             ),
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //       ],
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
