import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: categoryName,
          size: FontSizes.xxl,
          weight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: "24",
                      color: AppColors.primary,
                      size: FontSizes.xl,
                      weight: FontWeight.w600,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      text: "notes found",
                      color: AppColors.textSecondary,
                      size: FontSizes.xl,
                      weight: FontWeight.w400,
                    ),
                  ],
                ),
                CustomText(
                  text: "Semester IV",
                  color: AppColors.textSecondary,
                  size: FontSizes.xl,
                  weight: FontWeight.w400,
                ),
              ],
            ),
            Divider(color: AppColors.textSecondary, thickness: 1, height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Bounce(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NoteDetailScreen(),
                        ),
                      );
                    },
                    child: PdfContainer(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
