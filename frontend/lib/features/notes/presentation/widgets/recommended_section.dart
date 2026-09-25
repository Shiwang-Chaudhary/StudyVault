import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/auth/providers/user_profile_provider.dart';
import 'package:study_vault/features/notes/presentation/screens/pdf_view_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/recommended_note_container.dart';
import 'package:study_vault/features/notes/providers/recommended_notes_provider.dart';

class RecommendedSection extends ConsumerWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSubjects = ref.watch(
      userProfileProvider.select((profile) => profile.value?.subjects),
    );
    final subjectString = userSubjects!.join(",");
    final recommendedProvider = ref.watch(
      recommendedNotesProvider(subjectString),
    );
    return recommendedProvider.when(
      error: (error, stackTrace) {
        return CustomText(
          text: error.toString(),
          color: Colors.redAccent,
          maxLines: 3,
        );
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
      data: (recommendedList) {
        return Column(
          children: [
            const SizedBox(height: 10),
            recommendedList.isEmpty
                ? SizedBox(
                    height: 100,
                    child: Center(
                      child: CustomText(
                        text: "No recommended PDFs for you",
                        size: FontSizes.md,
                        weight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : Column(
                    children: recommendedList
                        .map(
                          (note) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewScreen(
                                    pdfId: note.id,
                                    pathOrUrl: note.cloudinaryUrl,
                                    isLocal: false,
                                    title: note.title,
                                  ),
                                ),
                              );
                            },
                            child: RecommendedPdfContainer(note: note),
                          ),
                        )
                        .toList(),
                  ),
          ],
        );
      },
    );
  }
}
