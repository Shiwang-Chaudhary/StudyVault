import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:study_vault/core/storage/hive_providers.dart';
import 'package:study_vault/features/notes/data/models/pdf_history_model.dart';

class PdfHistoryDataSource {
  final Box<PdfHistoryModel> _pdfHistoryBox;
  PdfHistoryDataSource(this._pdfHistoryBox);

  Future<void> savePdfHistory(PdfHistoryModel pdfHistory) async {
    await _pdfHistoryBox.put(pdfHistory.pdfId, pdfHistory);
  }

  Future<PdfHistoryModel?> getPdfHistory(String pdfId) async {
    return _pdfHistoryBox.get(pdfId);
  }

  Future<void> deletePdfHistory(String pdfId) async {
    await _pdfHistoryBox.delete(pdfId);
  }

  List<PdfHistoryModel> getAllPdfHistory() {
    final history = _pdfHistoryBox.values.toList();

    history.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));

    return history;
  }
}

final pdfHistoryDataSourceProvider = Provider<PdfHistoryDataSource>((ref) {
  final box = ref.watch(pdfHistoryBoxProvider);
  return PdfHistoryDataSource(box);
});
