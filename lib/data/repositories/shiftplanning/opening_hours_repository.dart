import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:coffeecard/models/opening_hours_day.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:collection/collection.dart';

class OpeningHoursRepository {
  OpeningHoursRepository({
    required this.api,
    required this.executor,
  });

  final ShiftplanningApi api;
  final Executor executor;

  Future<Either<RequestError, bool>> isOpen() async {
    return executor.execute(
      () => api.apiOpenShortKeyGet(shortKey: 'analog'),
      (dto) => dto.open,
    );
  }

  Future<Either<RequestError, Map<int, String>>> getOpeningHours() async {
    return executor.execute(
      () => api.apiShiftsShortKeyGet(shortKey: 'analog'),
      _transformOpeningHours,
    );
  }

  Map<int, String> _transformOpeningHours(List<OpeningHoursDTO> dtoList) {
    final content = dtoList..sortBy((dto) => dto.start);

    final openingHoursPerWeekday =
        groupBy<OpeningHoursDTO, int>(content, (dto) => dto.start.weekday);

    // create map associating each weekday to its opening hours:
    // {
    //   0: 8 - 16,
    //   1: 8 - 16, ...
    // }
    final weekDayOpeningHours = openingHoursPerWeekday.map(
      (day, value) => MapEntry(
        day,
        OpeningHoursDay(value.first.start, value.last.end).toString(),
      ),
    );

    // closed string is not capitalized
    var closed = Strings.closed;
    closed = closed.replaceFirst(closed[0], closed[0].toUpperCase());

    // the previous map only contains weekdays, mark weekends as closed
    weekDayOpeningHours.addAll({
      DateTime.saturday: closed,
      DateTime.sunday: closed,
    });

    return weekDayOpeningHours;
  }
}
