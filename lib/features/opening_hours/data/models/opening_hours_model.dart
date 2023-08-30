import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/extensions/string_extensions.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.models.swagger.dart';
import 'package:coffeecard/models/opening_hours_day.dart';

class OpeningHoursModel extends OpeningHours {
  const OpeningHoursModel({
    required super.allOpeningHours,
    required super.todaysOpeningHours,
  });

  // An [OpeningHoursDTO] actually represents a barista shift, so "dto.start"
  // means the start of the shift and "dto.end" means the end of the shift.
  factory OpeningHoursModel.fromDTO(List<OpeningHoursDTO> shifts) {
    final openingHours = _transformOpeningHours(shifts);
    final todaysOpeningHours = _calculateTodaysOpeningHours(
      DateTime.now().weekday,
      openingHours,
    );

    return OpeningHoursModel(
      allOpeningHours: openingHours,
      todaysOpeningHours: todaysOpeningHours,
    );
  }

  static Map<int, String> _transformOpeningHours(
    List<OpeningHoursDTO> allShifts,
  ) {
    final shiftsByWeekday = <int, List<OpeningHoursDTO>>{
      DateTime.monday: [],
      DateTime.tuesday: [],
      DateTime.wednesday: [],
      DateTime.thursday: [],
      DateTime.friday: [],
      DateTime.saturday: [],
      DateTime.sunday: [],
    };

    for (final shift in allShifts) {
      final weekday = shift.start.weekday;
      shiftsByWeekday[weekday]!.add(shift);
    }

    // For each weekday, map the shifts to a string representation of the
    // opening hours e.g '8 - 16' or 'Closed'
    //
    // This assumes that the shifts are sorted by start time and that there are
    // no overlapping shifts.
    return shiftsByWeekday.map(
      (day, shifts) => MapEntry(
        day,
        shifts.isEmpty
            ? Strings.closed.capitalize()
            : OpeningHoursDay(shifts.first.start, shifts.last.end).toString(),
      ),
    );
  }

  /// Return the current weekday and the corresponding opening hours e.g
  /// 'Mondays: 8 - 16'
  static String _calculateTodaysOpeningHours(
    int weekday,
    Map<int, String> openingHours,
  ) {
    final weekdayPlural = Strings.weekdaysPlural[weekday]!;
    final hours = openingHours[weekday];
    return '$weekdayPlural: $hours';
  }
}
