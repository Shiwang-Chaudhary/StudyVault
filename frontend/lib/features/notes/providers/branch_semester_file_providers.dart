import 'package:flutter_riverpod/legacy.dart';
import 'package:file_picker/file_picker.dart';

final branchStateProvider = StateProvider<String?>((ref) {
  return null;
});
final semesterStateProvider = StateProvider<String?>((ref) {
  return null;
});

final selectedFileProvider = StateProvider<PlatformFile?>((ref) => null);
