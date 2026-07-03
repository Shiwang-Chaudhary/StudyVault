import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/sub_tab.dart';

class UploaderProfileScreen extends StatefulWidget {
  const UploaderProfileScreen({super.key});

  @override
  State<UploaderProfileScreen> createState() => _UploaderProfileScreenState();
}

class _UploaderProfileScreenState extends State<UploaderProfileScreen> {
  int selectedSegment = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: " Profile",
          size: FontSizes.xxl,
          weight: FontWeight.w600,
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.border, width: 2),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
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
              CustomText(
                text: "Shiwang Chaudhary",
                size: FontSizes.xxl,
                weight: FontWeight.w600,
              ),
              CustomText(
                text: "Gurugram University | CSE",
                size: FontSizes.lg,
                weight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
              CustomText(
                text: "Joined Jan 2026",
                size: FontSizes.md,
                weight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          children: [
                            CustomText(
                              text: "540",
                              size: FontSizes.xxl,
                              color: AppColors.textPrimary,
                            ),
                            CustomText(
                              text: "Downloads",
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
              ),
              Divider(color: AppColors.border, thickness: 1, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const CustomText(
                    text: "Notes by name",
                    size: FontSizes.xxl,
                    weight: FontWeight.w600,
                  ),
                  // SegmentedButton<int>(
                  //   showSelectedIcon: false,
                  //   segments: const [
                  //     ButtonSegment(value: 0, label: Text('Top rated')),
                  //     ButtonSegment(value: 1, label: Text('Recent')),
                  //   ],
                  //   selected: {selectedSegment == 0 ? 0 : 1},
                  //   onSelectionChanged: (value) {},
                  //   style: ButtonStyle(
                  //     backgroundColor: WidgetStateProperty.resolveWith((
                  //       states,
                  //     ) {
                  //       if (states.contains(WidgetState.selected)) {
                  //         return const Color(0xFF6C63FF);
                  //       }
                  //       return Colors.transparent;
                  //     }),
                  //     foregroundColor: WidgetStateProperty.resolveWith((
                  //       states,
                  //     ) {
                  //       if (states.contains(WidgetState.selected)) {
                  //         return Colors.white;
                  //       }
                  //       return Colors.grey;
                  //     }),
                  //     side: WidgetStateProperty.all(
                  //       const BorderSide(color: Color(0xFF30334A)),
                  //     ),
                  //     shape: WidgetStateProperty.all(
                  //       RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Row(
                    children: [
                      SubTab(isSelected: true, title: "Top rated"),
                      SubTab(title: "Recent", isSelected: false),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return PdfContainer();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
