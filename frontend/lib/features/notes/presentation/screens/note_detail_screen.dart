import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/models/local_pdf_model.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';
import 'package:study_vault/features/notes/data/pdf_local_data_source.dart';
import 'package:study_vault/features/notes/presentation/screens/pdf_view_screen.dart';
import 'package:study_vault/features/notes/providers/notes_download_notifier.dart';
import 'package:study_vault/features/profile/presentation/screens/uploader_profile_screen.dart';

class NoteDetailScreen extends ConsumerWidget {
  final Note? note;
  final int? totalNotes;
  final String? params;
  const NoteDetailScreen({super.key, this.note, this.totalNotes, this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadNote = ref.watch(noteDownloadProvider);
    Map<String, dynamic> containerData = {
      "Downloads":
          downloadNote.value?.downloadCount.toString() ??
          note?.downloadCount.toString(),
      "Rating": note?.ratingCount.toString() ?? "0.0",
      "Likes": note?.likeCount.toString() ?? "0",
    };
    final items = containerData.entries.toList();
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Note Detail",
          size: FontSizes.xxl,
          weight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                log("Pdf name: ${note?.title}");
                log("Pdf url: ${note?.cloudinaryUrl}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfViewScreen(
                      pdfId: note?.id ?? "dummy_id",
                      isLocal: false,
                      title: note?.title ?? "Dummy title",
                      pathOrUrl:
                          note?.cloudinaryUrl ??
                          "https://res.cloudinary.com/demo/image/upload/sample.pdf",
                    ),
                  ),
                );
              },
              child: Container(
                height: 170,
                // margin: const EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: CustomText(
                    text: "PDF Viewer Placeholder",
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomText(
              text: note?.title ?? "Operating ////Systems Unit 2 — Deadlocks",
              size: FontSizes.xxxl,
              maxLines: 2,
              weight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            CustomText(
              text:
                  "${note?.branch ?? "CSE"} · Semester ${note?.semester ?? "IV"} · ${note?.pageCount ?? 0} pages",
              size: FontSizes.xl,
              maxLines: 2,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploaderProfileScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.infoMuted,
                    child: CustomText(
                      text: "SC",
                      color: AppColors.info,
                      size: FontSizes.lg,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Shiwang Chaudhary",
                        size: FontSizes.lg,
                        weight: FontWeight.w600,
                      ),
                      CustomText(
                        text: "${totalNotes ?? "0"} notes uploaded",
                        size: FontSizes.md,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                items.length,
                (index) => Expanded(
                  child: Container(
                    height: 80,
                    margin: const EdgeInsets.only(top: 20, left: 6, right: 6),
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
                            text: items[index].value,
                            size: FontSizes.xxl,
                            color: AppColors.textPrimary,
                          ),
                          CustomText(
                            text: items[index].key,
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
            const SizedBox(height: 20),
            Bounce(
              onTap: downloadNote.isLoading
                  ? null
                  : () async {
                      if (note?.id == null) return;
                      final result = await ref
                          .read(noteDownloadProvider.notifier)
                          .downloadNote(note!.id);
                      final file = result?.file;
                      if (file != null) {
                        final pdfDoc = LocalPdfModel(
                          id: note!.id,
                          title: note!.title,
                          localPath: file.path,
                          downloadedAt: DateTime.now(),
                          fileSize: (await file.length()).toString(),
                        );
                        await ref
                            .read(pdfLocalDataSourceProvider)
                            .savePdf(pdfDoc);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Note downloaded successfully"),
                          ),
                        );
                      }
                      //if user leaves screen, snackbar still runs so we need to stop that using this:
                      if (!context.mounted) return;
                      // Download failed.
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to download note"),
                          ),
                        );
                        return;
                      }
                    },
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
                      Iconsax.document_download,
                      color: AppColors.textPrimary,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    CustomText(
                      text: "Download",
                      size: FontSizes.xl,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: AppColors.border, height: 40, thickness: 1),
            CustomText(
              text: "Rate this note",
              size: FontSizes.xxl,
              weight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.star_border_outlined,
                color: AppColors.textTertiary,
                size: 36,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Reviews",
                  size: FontSizes.xxl,
                  weight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                TextButton(
                  onPressed: () {},
                  child: CustomText(text: "See all", color: AppColors.primary),
                ),
              ],
            ),
            Column(
              children: List.generate(
                2,
                (index) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      CustomText(
                        text: "Name ${index + 1}",
                        size: FontSizes.lg,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            color: AppColors.accentAmber,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
