import 'package:coffeecard/base/strings.dart';

String timeSince(DateTime time) {
  String monthsAgo(int days) {
    final months = days ~/ 30.5;
    final monthsStr =
        months == 1 ? Strings.aMonth : '$months ${Strings.months}';
    return '${Strings.around} $monthsStr ${Strings.ago}';
  }

  String yearsAgo(int days) {
    final years = days ~/ 365;
    final rest = days % 365;
    if (rest > 305) return '${Strings.almost} ${years + 1} ${Strings.yearsAgo}';
    if (rest < 60) return '${Strings.around} $years ${Strings.yearsAgo}';
    return '${Strings.moreThan} $years ${Strings.yearsAgo}';
  }

  final currentTime = DateTime.now();
  final diff = currentTime.difference(time);

  if (diff.inMinutes < 2) return Strings.justNow;
  if (diff.inHours < 1) return '${diff.inMinutes} ${Strings.minutesAgo}';
  if (diff.inHours == 1) return Strings.anHourAgo;
  if (diff.inHours < 8) return '${diff.inHours} ${Strings.hoursAgo}';
  if (diff.inDays == 0) return Strings.earlierToday;
  if (diff.inDays == 1) return Strings.yesterday;
  if (diff.inDays < 31) return '${diff.inDays} ${Strings.daysAgo}';
  if (diff.inDays < 365) return monthsAgo(diff.inDays);
  return yearsAgo(diff.inDays);
}
