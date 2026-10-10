import 'package:intl/intl.dart';

String formatLostfoundDate(String raw, {bool includeTime = true}) {
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return '';
  return DateFormat(
    includeTime ? 'M월 d일 HH:mm' : 'M월 d일',
    'ko_KR',
  ).format(parsed.toLocal());
}
