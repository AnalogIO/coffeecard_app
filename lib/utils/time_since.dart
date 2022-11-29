import 'package:coffeecard/base/strings.dart';

String timeSince(DateTime time, {DateTime? now}) {
  // Set `now` if not provided
  now ??= DateTime.now();

  final diff = now.difference(time);

  // future
  if (diff.inMinutes < -1) return Strings.inTheFuture;

  // just now, minutes ago, hours ago
  if (diff.inMinutes < 1) return Strings.justNow;
  if (diff.inHours < 1) return Strings.minutesAgo(diff.inMinutes);
  if (diff.inHours < 8) return Strings.hoursAgo(diff.inHours);

  // earlier today, yesterday, days ago
  if (diff.inDays == 0 && time.day == now.day) return Strings.earlierToday;
  if (diff.inDays <= 1) return Strings.yesterday;
  if (diff.inDays <= 25) return Strings.daysAgo(diff.inDays);

  // months ago, years ago
  if (diff.inDays <= 345) return _monthsAgo(days: diff.inDays);
  return _yearsAgo(days: diff.inDays);
}

String _monthsAgo({required int days}) {
  final months = days ~/ 30.5;
  final remainder = days % 30.5;

  // if remainder is less than 2 days, return x months ago
  if (remainder < 2) return Strings.monthsAgo(months);
  // if remainder is more than 28 days, return x+1 months ago
  if (remainder > 28) return Strings.monthsAgo(months + 1);

  // if remainder is less than 5 days, return around x months ago
  if (remainder < 5) return Strings.around(Strings.monthsAgo(months));
  // if remainder is more than 25 days, return almost x+1 months ago
  if (remainder > 25) return Strings.almost(Strings.monthsAgo(months + 1));

  return Strings.moreThan(Strings.monthsAgo(months));
}

String _yearsAgo({required int days}) {
  final years = days ~/ 365;
  final remainder = days % 365;

  // if remainder is less than 10 days, return x years ago
  if (remainder < 10) return Strings.yearsAgo(years);
  // if remainder is more than 355 days, return x+1 years ago
  if (remainder > 355) return Strings.yearsAgo(years + 1);

  // if remainder is less than 20 days, return around x years ago
  if (remainder < 20) return Strings.around(Strings.yearsAgo(years));
  // if remainder is more than 345 days, return almost x+1 years ago
  if (remainder > 345) return Strings.almost(Strings.yearsAgo(years + 1));

  return Strings.moreThan(Strings.yearsAgo(years));
}
