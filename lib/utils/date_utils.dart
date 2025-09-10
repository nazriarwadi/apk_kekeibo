import 'package:intl/intl.dart';

String formatDate(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('dd MMMM yyyy', 'id_ID').format(parsedDate);
}

// Format tanggal dengan nama hari (contoh: Senin, 3 April 2023)
String formatDateWithDay(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(parsedDate);
}
