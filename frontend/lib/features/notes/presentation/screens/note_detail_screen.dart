import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/models/local_pdf_model.dart';
import 'package:study_vault/features/notes/data/models/notes_model.dart';
import 'package:study_vault/features/notes/data/pdf_local_data_source.dart';
import 'package:study_vault/features/notes/presentation/screens/pdf_view_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/rating_section.dart';
import 'package:study_vault/features/notes/providers/bookmark_notifier.dart';
import 'package:study_vault/features/notes/providers/current_user_id_provider.dart';
import 'package:study_vault/features/notes/providers/isdownloaded_provider.dart';
import 'package:study_vault/features/notes/providers/notes_download_notifier.dart';
import 'package:study_vault/features/profile/presentation/screens/uploader_profile_screen.dart';

class NoteDetailScreen extends ConsumerWidget {
  final Note? note;
  final int? totalNotes;
  final String? params;
  const NoteDetailScreen({super.key, this.note, this.totalNotes, this.params});

  Future<void> _downloadNote(BuildContext context, WidgetRef ref) async {
    if (note?.id == null) return;
    final currentUserId = ref.read(currentUserIdProvider);
    final download = ref
        .read(pdfLocalDataSourceProvider)
        .getPdfById(note!.id, currentUserId);
    if (download != null) {
      ref.invalidate(
        isDownloadedProvider((noteId: note!.id, userId: currentUserId)),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Note already downloaded")));
      return;
    }
    final result = await ref
        .read(noteDownloadProvider.notifier)
        .downloadNote(note!.id, currentUserId);
    final file = result?.file;
    if (file != null) {
      final pdfDoc = LocalPdfModel(
        id: note!.id,
        userId: currentUserId,
        title: note!.title,
        localPath: file.path,
        downloadedAt: DateTime.now(),
        fileSize: (await file.length()).toString(),
      );
      await ref.read(pdfLocalDataSourceProvider).savePdf(pdfDoc, currentUserId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note downloaded successfully")),
      );
    }
    //if user leaves screen, snackbar still runs so we need to stop that using this:
    if (!context.mounted) return;
    // Download failed.
    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to download note")));
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final downloadNote = ref.watch(noteDownloadProvider);
    final isDownloaded = ref.watch(
      isDownloadedProvider((noteId: note?.id ?? " ", userId: currentUserId)),
    );
    final isDownloading = downloadNote.isLoading;
    final downloadLabel = isDownloading
        ? "Downloading..."
        : isDownloaded
        ? "Downloaded"
        : "Download";
    final downloadIcon = isDownloading
        ? Icons.downloading
        : isDownloaded
        ? Icons.download_done
        : Icons.download;
    Map<String, dynamic> containerData = {
      "Downloads":
          downloadNote.value?.downloadCount.toString() ??
          note?.downloadCount.toString(),
      "Rating": note?.avgRating.toString() ?? "0.0",
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
                if (isDownloaded) {
                  final downloadedPdf = ref
                      .read(pdfLocalDataSourceProvider)
                      .getPdfById(note?.id ?? " ", currentUserId);
                  log(
                    "Opening pdf using local path: ${downloadedPdf?.localPath}",
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewScreen(
                        pdfId: downloadedPdf?.id ?? "dummy_id",
                        isLocal: true,
                        pathOrUrl:
                            downloadedPdf?.localPath ??
                            "https://res.cloudinary.com/demo/image/upload/sample.pdf",
                        title: downloadedPdf?.title ?? "Dummy title",
                      ),
                    ),
                  );
                } else {
                  log(
                    "Opening pdf using cloudinary url: ${note?.cloudinaryUrl}",
                  );
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
                }
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
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text:
                          note?.title ??
                          "Operating ////Systems Unit 2 — Deadlocks",
                      size: FontSizes.xxl,
                      maxLines: 2,
                      weight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    CustomText(
                      text:
                          "${note?.branch ?? "CSE"} · Semester ${note?.semester ?? "IV"} · ${note?.pageCount ?? 0} pages",
                      size: FontSizes.lg,
                      maxLines: 2,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const Spacer(),
                Consumer(
                  builder: (context, ref, child) {
                    final isBookmarked =
                        ref
                            .watch(bookmarkProvider)
                            .value
                            ?.any((n) => n.id == note?.id) ??
                        false;

                    return IconButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        final noteId = note?.id;
                        if (noteId == null) return;
                        final notifier = ref.read(bookmarkProvider.notifier);
                        try {
                          if (isBookmarked) {
                            await notifier.deleteBookmark(noteId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Bookmark removed"),
                                ),
                              );
                            }
                          } else {
                            await notifier.addBookmark(noteId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Note bookmarked successfully"),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Something went wrong"),
                              ),
                            );
                          }
                        }
                      },
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_add,
                        color: AppColors.primary,
                        size: 34,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                log("Uploader user name: ${note?.user.name}");
                final loggedUserId = ref.read(currentUserIdProvider);
                if (loggedUserId == note?.user.id) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("This is your profile")),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UploaderProfileScreen(user: note!.user),
                    ),
                  );
                }
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
                        text: note!.user.name,
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
                      await _downloadNote(context, ref);
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
                    Icon(downloadIcon, color: AppColors.textPrimary, size: 28),
                    const SizedBox(width: 10),
                    CustomText(
                      text: downloadLabel,
                      size: FontSizes.xl,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: AppColors.border, height: 40, thickness: 1),
            Expanded(
              child: RatingSection(
                noteId: note?.id ?? "dummy_id",
                ownerId: note?.user.id ?? "dummy_owner_id",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
