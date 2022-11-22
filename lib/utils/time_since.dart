import 'package:coffeecard/base/strings.dart';

String timeSince(DateTime time) {
  final currentTime = DateTime.now();

  if (time.isAfter(currentTime)) {
    return Strings.inTheFuture;
  }

  final diff = currentTime.difference(time);

  if (diff.inMinutes < 2) return Strings.justNow;
  if (diff.inHours < 1) return '${diff.inMinutes} ${Strings.minutesAgo}';
  if (diff.inHours == 1) return Strings.anHourAgo;
  if (diff.inHours < 8) return '${diff.inHours} ${Strings.hoursAgo}';
  if (diff.inDays == 0) return Strings.earlierToday;
  if (diff.inDays == 1) return Strings.yesterday;
  if (diff.inDays < 31) return '${diff.inDays} ${Strings.daysAgo}';
  if (diff.inDays < 365) return monthsAgo(days: diff.inDays);
  return yearsAgo(days: diff.inDays);
}

String monthsAgo({required int days}) {
  final months = days ~/ 30.5;
  final rest = days % 30.5;
  if (rest > 28) return Strings.monthsAgo(months + 1);
  if (rest < 3) return Strings.monthsAgo(months);

  if (rest > 23) return '${Strings.almost} ${Strings.monthsAgo(months + 1)}';
  if (rest < 7) return '${Strings.around} ${Strings.monthsAgo(months)}';
  return '${Strings.moreThan} ${Strings.monthsAgo(months)}';
}

String yearsAgo({required int days}) {
  final years = days ~/ 365;
  final rest = days % 365;
  if (rest > 355) return Strings.yearsAgo(years + 1);
  if (rest < 10) return Strings.yearsAgo(years);

  if (rest > 305) return '${Strings.almost} ${Strings.yearsAgo(years + 1)}';
  if (rest < 60) return '${Strings.around} ${Strings.yearsAgo(years)}';
  return '${Strings.moreThan} ${Strings.yearsAgo(years)}';
}
