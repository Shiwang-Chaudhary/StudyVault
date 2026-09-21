import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/presentation/screens/pdf_view_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/providers/trending_notes_provider.dart';

class TrendingSection extends ConsumerWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingProvider = ref.watch(trendingNotesProvider);
    return trendingProvider.when(
      error: (error, stackTrace) {
        return CustomText(
          text: "Error: $error",
          color: Colors.redAccent,
          maxLines: 3,
        );
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
      data: (trendingList) {
        return Column(
          children: [
            const SizedBox(height: 10),
            trendingList.isEmpty
                ? SizedBox(
                    height: 100,
                    child: Center(
                      child: CustomText(
                        text: "No trending PDFs available",
                        size: FontSizes.md,
                        weight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : Column(
                    children: trendingList
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
                            child: PdfContainer(note: note),
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
