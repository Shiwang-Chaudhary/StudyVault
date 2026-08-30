import 'package:flutter_riverpod/legacy.dart';
import 'package:file_picker/file_picker.dart';

final branchStateProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});
final semesterStateProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final selectedFileProvider = StateProvider.autoDispose<PlatformFile?>(
  (ref) => null,
);
