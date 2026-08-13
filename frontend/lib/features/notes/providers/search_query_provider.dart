import 'package:flutter_riverpod/legacy.dart';

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => "");
