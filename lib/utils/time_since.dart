import 'package:coffeecard/base/strings.dart';

String timeSince(DateTime time) {
  final currentTime = DateTime.now();
  final difference = currentTime.difference(time);

  if (difference.inMinutes < 2) return Strings.justNow;
  if (difference.inHours < 8) return Strings.hoursAgo(difference.inHours);
  if (difference.inDays == 0) return Strings.earlierToday;
  if (difference.inDays == 1) return Strings.yesterday;
  return Strings.daysAgo(difference.inDays);
  // TODO potential to improve
  // if (difference.inDays < 31) return '${difference.inDays} days ago';
  // return 'Around ${difference.inDays ~/ 31} months ago';
}
