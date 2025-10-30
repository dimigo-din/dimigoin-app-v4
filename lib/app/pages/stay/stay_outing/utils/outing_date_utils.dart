import 'package:dimigoin_app_v4/app/services/stay/model.dart';

class OutingDateUtils {
  /// Stay 기간 동안의 모든 날짜 목록을 반환합니다.
  static List<DateTime> getOutingDays(Stay stay) {
    final from = DateTime.parse(stay.stayFrom);
    final to = DateTime.parse(stay.stayTo);
    final days = <DateTime>[];

    for (var date = from;
        date.isBefore(to) || date.isAtSameMomentAs(to);
        date = date.add(const Duration(days: 1))) {
      days.add(date);
    }

    return days;
  }

  /// 두 DateTime이 같은 날인지 확인합니다.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
