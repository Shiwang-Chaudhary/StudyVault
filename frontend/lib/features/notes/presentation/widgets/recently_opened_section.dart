import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/storage/hive_providers.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/pdf_history_data_source.dart';
import 'package:study_vault/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:study_vault/features/notes/presentation/screens/pdf_view_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/pdf_progress_card.dart';

class RecentlyOpenedSection extends ConsumerWidget {
  const RecentlyOpenedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pdfHistory = ref
        .watch(pdfHistoryDataSourceProvider)
        .getAllPdfHistory();
    return Column(
      children: [
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
        if (pdfHistory.isEmpty)
          SizedBox(
            height: 100,
            child: Center(
              child: CustomText(
                text: "No recently opened PDFs",
                size: FontSizes.md,
                weight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(pdfHistory.length, (index) {
                final pdf = pdfHistory[index];
                return Bounce(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewScreen(
                          isLocal: pdf?.isLocal ?? false,
                          pathOrUrl: pdf?.localPathOrUrl ?? '',
                          pdfId: pdf?.pdfId ?? '',
                          title: pdf?.title,
                        ),
                      ),
                    );
                  },
                  child: PdfProgressCard(
                    title: pdf?.title ?? "Untitled PDF",
                    currentPage: pdf?.lastPage ?? 0,
                    totalPages: pdf?.totalPages ?? 20,
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
