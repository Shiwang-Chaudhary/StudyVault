// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_ce/hive_ce.dart';
// import 'package:study_vault/core/storage/hive_providers.dart';
// import 'package:study_vault/features/notes/data/models/pdf_history_model.dart';

// class PdfHistoryDataSource {
//   final Box<PdfHistoryModel> _pdfHistoryBox;
//   PdfHistoryDataSource(this._pdfHistoryBox);

//   Future<void> savePdfHistory(PdfHistoryModel pdfHistory) async {
//     await _pdfHistoryBox.put(pdfHistory.pdfId, pdfHistory);
//   }

//   Future<PdfHistoryModel?> getPdfHistory(String pdfId) async {
//     return _pdfHistoryBox.get(pdfId);
//   }

//   Future<void> deletePdfHistory(String pdfId) async {
//     await _pdfHistoryBox.delete(pdfId);
//   }

//   List<PdfHistoryModel> getAllPdfHistory() {
//     final history = _pdfHistoryBox.values.toList();

//     history.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));

//     return history.take(5).toList();
//   }
// }

// final pdfHistoryDataSourceProvider = Provider<PdfHistoryDataSource>((ref) {
//   final box = ref.watch(pdfHistoryBoxProvider);
//   return PdfHistoryDataSource(box);
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:study_vault/core/storage/hive_providers.dart';
import 'package:study_vault/features/notes/data/models/pdf_history_model.dart';

class PdfHistoryDataSource {
  final Box<PdfHistoryModel> _pdfHistoryBox;

  PdfHistoryDataSource(this._pdfHistoryBox);

  // Creates a unique key for each user's PDF history.
  String _key(String pdfId, String userId) {
    return '$userId:$pdfId';
  }

  // Save PDF history for a specific user.
  Future<void> savePdfHistory(PdfHistoryModel pdfHistory, String userId) async {
    await _pdfHistoryBox.put(_key(pdfHistory.pdfId, userId), pdfHistory);
  }

  // Get history for a specific PDF and user.
  PdfHistoryModel? getPdfHistory(String pdfId, String userId) {
    return _pdfHistoryBox.get(_key(pdfId, userId));
  }

  // Delete history for a specific PDF and user.
  Future<void> deletePdfHistory(String pdfId, String userId) async {
    await _pdfHistoryBox.delete(_key(pdfId, userId));
  }

  // Get all PDF history for a specific user.
  List<PdfHistoryModel> getAllPdfHistory(String userId) {
    final history = _pdfHistoryBox.values
        .where((pdf) => pdf.userId == userId)
        .toList();

    history.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));

    return history.take(5).toList();
  }
}

// Data source provider.
final pdfHistoryDataSourceProvider = Provider<PdfHistoryDataSource>((ref) {
  final pdfHistoryBox = ref.watch(pdfHistoryBoxProvider);

  return PdfHistoryDataSource(pdfHistoryBox);
});

// // Get the latest 5 PDF histories for a specific user.
// final pdfHistoryStreamProvider = StreamProvider.autoDispose
//     .family<List<PdfHistoryModel>, String>((ref, userId) {
//       final dataSource = ref.watch(pdfHistoryDataSourceProvider);

//       return dataSource.getAllPdfHistory(userId);
//     });
