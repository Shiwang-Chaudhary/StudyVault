import 'package:intl/intl.dart';

String formatJoinedDate(String? date) {
  if (date == null || date.isEmpty) return '';

  final parsedDate = DateTime.parse(date).toLocal();
  return DateFormat('d MMMM yyyy').format(parsedDate);
}
