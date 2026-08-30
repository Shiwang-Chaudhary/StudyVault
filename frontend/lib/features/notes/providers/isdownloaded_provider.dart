import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_vault/features/notes/data/pdf_local_data_source.dart';

final isDownloadedProvider = Provider.autoDispose
    .family<bool, ({String noteId, String userId})>((ref, params) {
      final isDownloaded = ref
          .watch(pdfLocalDataSourceProvider)
          .getPdfById(params.noteId, params.userId);
      return isDownloaded != null;
    });
