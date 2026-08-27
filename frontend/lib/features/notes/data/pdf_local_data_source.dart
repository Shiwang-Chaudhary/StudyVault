import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:study_vault/core/storage/hive_providers.dart';
import 'package:study_vault/features/notes/data/models/local_pdf_model.dart';

class PdfLocalDataSource {
  final Box<LocalPdfModel> _pdfBox;
  PdfLocalDataSource(this._pdfBox);

  Future<void> savePdf(LocalPdfModel pdf) async {
    await _pdfBox.put(pdf.id, pdf);
  }

  Future<void> deletePdf(String pdfId) async {
    await _pdfBox.delete(pdfId);
  }

  Stream<List<LocalPdfModel?>> getAllPdf() async* {
    yield _pdfBox.values.toList();

    yield* _pdfBox.watch().map((event) => _pdfBox.values.toList());
  }
}

final pdfLocalDataSourceProvider = Provider<PdfLocalDataSource>((ref) {
  final pdfBox = ref.watch(pdfBoxProvider);
  return PdfLocalDataSource(pdfBox);
});

final downloadPdfStreamProvider = StreamProvider<List<LocalPdfModel?>>((ref) {
  final pdfLocalDataSource = ref.watch(pdfLocalDataSourceProvider);
  return pdfLocalDataSource.getAllPdf();
});
