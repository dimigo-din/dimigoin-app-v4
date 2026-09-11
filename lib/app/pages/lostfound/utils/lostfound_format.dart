import 'package:intl/intl.dart';

String formatLostfoundDate(String raw) {
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return '';
  return DateFormat('M월 d일 HH:mm', 'ko_KR').format(parsed.toLocal());
}
