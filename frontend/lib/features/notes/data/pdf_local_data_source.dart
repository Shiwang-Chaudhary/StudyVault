import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:study_vault/core/storage/hive_providers.dart';
import 'package:study_vault/features/notes/data/models/local_pdf_model.dart';

class PdfLocalDataSource {
  final Box<LocalPdfModel> _pdfBox;

  PdfLocalDataSource(this._pdfBox);

  // Creates a unique key for each user's downloaded note.
  String _key(String noteId, String userId) {
    return '$userId:$noteId';
  }

  // Save a downloaded PDF.
  Future<void> savePdf(LocalPdfModel pdf, String userId) async {
    await _pdfBox.put(_key(pdf.id, userId), pdf);
  }

  // Delete a downloaded PDF.
  Future<void> deletePdf(String noteId, String userId) async {
    await _pdfBox.delete(_key(noteId, userId));
  }

  // Check/get a downloaded PDF for a specific user.
  LocalPdfModel? getPdfById(String noteId, String userId) {
    return _pdfBox.get(_key(noteId, userId));
  }

  // Get all PDFs downloaded by a specific user.
  Stream<List<LocalPdfModel>> getAllPdf(String userId) async* {
    List<LocalPdfModel> getUserPdfs() {
      return _pdfBox.values.where((pdf) => pdf.userId == userId).toList();
    }

    // Initial data.
    yield getUserPdfs();

    // Listen for changes.
    yield* _pdfBox.watch().map((_) => getUserPdfs());
  }
}

// Data source provider.
final pdfLocalDataSourceProvider = Provider<PdfLocalDataSource>((ref) {
  final pdfBox = ref.watch(pdfBoxProvider);

  return PdfLocalDataSource(pdfBox);
});

// Get all downloaded PDFs for a specific user.
final downloadPdfStreamProvider = StreamProvider.autoDispose
    .family<List<LocalPdfModel>, String>((ref, userId) {
      final pdfLocalDataSource = ref.watch(pdfLocalDataSourceProvider);

      return pdfLocalDataSource.getAllPdf(userId);
    });
