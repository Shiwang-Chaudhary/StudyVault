import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_colors.dart';
import 'package:study_vault/core/config/app_font_size.dart';
import 'package:study_vault/core/widgets/custom_text.dart';
import 'package:study_vault/features/notes/data/pdf_local_data_source.dart';
import 'package:study_vault/features/notes/presentation/screens/pdf_view_screen.dart';
import 'package:study_vault/features/notes/presentation/widgets/downloaded_item_container.dart';
import 'package:study_vault/features/notes/providers/current_user_id_provider.dart';

class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    log('Current User ID inside download screen: $userId');

    final downloadedPdfs = ref.watch(downloadPdfStreamProvider(userId));
    return downloadedPdfs.when(
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      data: (pdfList) {
        log('Downloaded PDFs: $pdfList');
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                AppBar(
                  title: CustomText(
                    text: 'Download',
                    size: FontSizes.xl,
                    weight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    CustomText(
                      text: 'Total Downloads: ',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PdfViewScreen(
                                pdfId: pdf!.id,
                                isLocal: true,
                                pathOrUrl: pdf.localPath,
                                title: pdf.title,
                              ),
                            ),
                          );
                        },
                        child: DownloadedItemContainer(pdf: pdf),
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
