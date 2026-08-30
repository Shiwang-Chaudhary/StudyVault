import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/presentation/screens/pdf_view_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/bookmark_pdf_container.dart';
import 'package:study_vault/features/notes/presentation/widgets/downloaded_item_container.dart';
import 'package:study_vault/features/notes/providers/bookmark_notifier.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedNotes = ref.watch(bookmarkProvider);
    return bookmarkedNotes.when(
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return Scaffold(body: Center(child: Text('Error: $error')));
      },
      data: (pdfList) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                AppBar(
                  title: CustomText(
                    text: 'Bookmarks',
                    size: FontSizes.xl,
                    weight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    CustomText(
                      text: 'Total Bookmarks: ',
                      size: FontSizes.lg,
                      weight: FontWeight.w400,
                    ),
                    CustomText(
                      text: '${pdfList.length}',
                      color: AppColors.primary,
                      size: FontSizes.lg,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: const Color.fromARGB(255, 107, 106, 106)),
                SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: pdfList.length,
                    itemBuilder: (context, index) {
                      final pdf = pdfList[index];
                      return GestureDetector(
                        onTap: () {
                          log("pdf cloudinary url: ${pdf.cloudinaryUrl}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PdfViewScreen(
                                pdfId: pdf.id,
                                isLocal: false,
                                pathOrUrl: pdf.cloudinaryUrl,
                                title: pdf.title,
                              ),
                            ),
                          );
                        },
                        child: BookmarkPdfContainer(note: pdf),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
