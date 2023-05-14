import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/utils/time_since.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final midday = DateTime(2019, 1, 1, 12);
  group('time since tests', () {
    test(
      'time since given midday and 5m in the future returns in the future',
      () {
        expect(
          timeSince(midday.add(const Duration(minutes: 5)), now: midday),
          Strings.inTheFuture,
        );
      },
    );

    test('time since given midday and 1m in the future returns just now', () {
      expect(
        timeSince(midday.add(const Duration(minutes: 1)), now: midday),
        Strings.justNow,
      );
    });
    test('time since given midday and 30s prior returns just now', () {
      expect(
        timeSince(
          midday.subtract(const Duration(seconds: 30)),
          now: midday,
        ),
        Strings.justNow,
      );
    });
    test('time since given midday and 1m30s prior returns a minute ago', () {
      expect(
        timeSince(
          midday.subtract(const Duration(minutes: 1, seconds: 30)),
          now: midday,
        ),
        Strings.minutesAgo(1),
      );
    });
    test('time since given midday and 55m prior returns 55 minutes ago', () {
      expect(
        timeSince(midday.subtract(const Duration(minutes: 55)), now: midday),
        Strings.minutesAgo(55),
      );
    });
    test('time since given midday and 1h prior returns an hour ago', () {
      expect(
        timeSince(midday.subtract(const Duration(hours: 1)), now: midday),
        Strings.hoursAgo(1),
      );
    });
    test('time since given midday and 4h prior returns 4 hours ago', () {
      expect(
        timeSince(midday.subtract(const Duration(hours: 4)), now: midday),
        Strings.hoursAgo(4),
      );
    });
    test('time since given midday and 8h prior returns earlier today', () {
      expect(
        timeSince(midday.subtract(const Duration(hours: 8)), now: midday),
        Strings.earlierToday,
      );
    });
    test('time since given midday and 1d prior returns yesterday', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 1)), now: midday),
        Strings.yesterday,
      );
    });
    test('time since given midday and 2d prior returns 2 days ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 2)), now: midday),
        Strings.daysAgo(2),
      );
    });
    test('time since given midday and 25d prior returns 25 days ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 25)), now: midday),
        Strings.daysAgo(25),
      );
    });

    // Months
    test(
      'time since given midday and 27d prior returns almost a month ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 27)), now: midday),
          Strings.almost(
            Strings.monthsAgo(1),
          ),
        );
      },
    );
    test(
      'time since given midday and 28d prior returns almost a month ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 28)), now: midday),
          Strings.almost(Strings.monthsAgo(1)),
        );
      },
    );
    test('time since given midday and 29d prior returns a month ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 29)), now: midday),
        Strings.monthsAgo(1),
      );
    });
    test('time since given midday and 31d prior returns a month ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 31)), now: midday),
        Strings.monthsAgo(1),
      );
    });
    test(
      'time since given midday and 34d prior returns around a month ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 34)), now: midday),
          Strings.around(Strings.monthsAgo(1)),
        );
      },
    );
    test(
      'time since given midday and 40d prior returns more than a month ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 40)), now: midday),
          Strings.moreThan(Strings.monthsAgo(1)),
        );
      },
    );
    test('time since given midday and 60d prior returns 2 months ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 60)), now: midday),
        Strings.monthsAgo(2),
      );
    });
    test('time since given midday and 62d prior returns 2 months ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 62)), now: midday),
        Strings.monthsAgo(2),
      );
    });
    test(
      'time since given midday and 70d prior returns more than 2 months ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 70)), now: midday),
          Strings.moreThan(Strings.monthsAgo(2)),
        );
      },
    );
    test(
      'time since given midday and 345d prior returns more than 11 months ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 345)), now: midday),
          Strings.moreThan(Strings.monthsAgo(11)),
        );
      },
    );
    test(
      'time since given midday and 346d prior returns almost a year ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 346)), now: midday),
          Strings.almost(Strings.yearsAgo(1)),
        );
      },
    );
    test('time since given midday and 360d prior returns a year ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 360)), now: midday),
        Strings.yearsAgo(1),
      );
    });
    test('time since given midday and 365d prior returns a year ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 365)), now: midday),
        Strings.yearsAgo(1),
      );
    });
    test('time since given midday and 370d prior returns a year ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 370)), now: midday),
        Strings.yearsAgo(1),
      );
    });
    test(
      'time since given midday and 380d prior returns more than a year ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 380)), now: midday),
          Strings.around(Strings.yearsAgo(1)),
        );
      },
    );
    test(
      'time since given midday and 400d prior returns more than a year ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 400)), now: midday),
          Strings.moreThan(Strings.yearsAgo(1)),
        );
      },
    );
    test(
      'time since given midday and 600d prior returns more than a year ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 600)), now: midday),
          Strings.moreThan(Strings.yearsAgo(1)),
        );
      },
    );
    test('time since given midday and 730d prior returns 2 years ago', () {
      expect(
        timeSince(midday.subtract(const Duration(days: 730)), now: midday),
        Strings.yearsAgo(2),
      );
    });
    test(
      'time since given midday and 920d prior returns more than 2 years ago',
      () {
        expect(
          timeSince(midday.subtract(const Duration(days: 920)), now: midday),
          Strings.moreThan(Strings.yearsAgo(2)),
        );
      },
    );
  });
}
