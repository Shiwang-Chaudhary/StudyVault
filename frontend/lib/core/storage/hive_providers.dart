// lib/core/storage/hive_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:study_vault/features/notes/data/models/local_pdf_model.dart';

final pdfBoxProvider = Provider<Box<LocalPdfModel>>((ref) {
  // Note: Added <Box<LocalPdfDocument>>
  throw UnimplementedError('pdfBoxProvider must be overridden in main()');
});
