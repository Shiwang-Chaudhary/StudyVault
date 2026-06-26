import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/constans/college_branches.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/core/widgets/custom_text_field.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/sub_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              SizedBox(
                height: 40,
                child: ListView.builder(
                  itemCount: AppConstants.mvpSubjectsByBranch["CSE"]!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AppConstants.mvpSubjectsByBranch["CSE"]!.isNotEmpty
                        ? SubTab(
                            title:
                                AppConstants.mvpSubjectsByBranch["CSE"]![index],
                            isSelected: true,
                            onTap: () {},
                          )
                        : SubTab(title: "All", isSelected: true, onTap: () {});
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Trending Notes",
                    size: FontSizes.xxl,
                    weight: FontWeight.w600,
                  ),
                  CustomText(
                    text: "See All",
                    size: FontSizes.lg,
                    weight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ],
              ),
              Column(children: List.generate(3, (_) => const PdfContainer())),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 10),
                itemCount: AppConstants.mvpSubjectsByBranch["CSE"]!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text:
                                AppConstants.mvpSubjectsByBranch["CSE"]![index],
                            size: FontSizes.xxl,
                            weight: FontWeight.w600,
                          ),
                          CustomText(
                            text: "See All",
                            size: FontSizes.lg,
                            weight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 355,
                        width: double.infinity,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: 5,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return PdfContainer();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
