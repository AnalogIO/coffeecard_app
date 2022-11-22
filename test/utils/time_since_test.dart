import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/utils/time_since.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('years ago tests', () {
    test('years ago given date exactly one year ago returns correct string',
        () {
      expect(yearsAgo(days: 365), '${Strings.around} 1 ${Strings.yearsAgo}');
    });
    test(
        'years ago given date more than one and a half year ago returns correct string',
        () {
      expect(yearsAgo(days: 600), '${Strings.moreThan} 1 ${Strings.yearsAgo}');
    });
    test(
        'years ago given date more than two and a half years ago returns correct string',
        () {
      expect(yearsAgo(days: 650), '${Strings.moreThan} 1 ${Strings.yearsAgo}');
    });
  });

  group('months ago tests', () {
    test('months ago given date exactly one month ago returns correct string',
        () {
      expect(monthsAgo(days: 31),
          '${Strings.around} ${Strings.aMonth} ${Strings.ago}');
    });

    test('months ago given date two months ago returns correct string', () {
      expect(monthsAgo(days: 62),
          '${Strings.around} 2 ${Strings.months} ${Strings.ago}');
    });
  });

  group('time since tests', () {
    test('time since given date in the future returns in the future', () {
      expect(
        timeSince(DateTime.now().add(const Duration(minutes: 1))),
        Strings.inTheFuture,
      );
    });

    test('time since given 1 min 30 sec difference returns just now', () {
      expect(
        timeSince(
          DateTime.now().subtract(const Duration(minutes: 1, seconds: 30)),
        ),
        Strings.justNow,
      );
    });
    test('time since given 55 min difference returns 55 minutes ago', () {
      expect(
        timeSince(DateTime.now().subtract(const Duration(minutes: 55))),
        '55 ${Strings.minutesAgo}',
      );
    });
    test('time since given 1 hour difference returns an hour ago', () {
      expect(
        timeSince(DateTime.now().subtract(const Duration(hours: 1))),
        Strings.anHourAgo,
      );
    });
    test('time since given 4 hour difference returns 4 hours ago', () {
      expect(
        timeSince(DateTime.now().subtract(const Duration(hours: 4))),
        '4 ${Strings.hoursAgo}',
      );
    });
    test('time since given more than 8 hour difference returns earlier today',
        () {
      expect(
        timeSince(DateTime.now().subtract(const Duration(hours: 9))),
        Strings.earlierToday,
      );
    });

    test('time since given 24 hour difference returns yesterday', () {
      expect(
        timeSince(DateTime.now().subtract(const Duration(days: 1))),
        Strings.yesterday,
      );
    });

    test('time since given 27 day difference returns 27 days ago', () {
      expect(
        timeSince(DateTime.now().subtract(const Duration(days: 27))),
        '27 ${Strings.daysAgo}',
      );
    });
  });
}
