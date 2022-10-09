import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/opening_hours_day.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

class OpeningHoursRepository {
  final ShiftplanningApi _api;
  final Logger _logger;

  OpeningHoursRepository(this._api, this._logger);

  Future<Either<ApiError, bool>> isOpen() async {
    final response = await _api.apiOpenShortKeyGet(
      shortKey: 'analog',
    );

    if (response.isSuccessful) {
      return Right(response.body!.open);
    } else {
      _logger.e(response.formatError());
      throw Left(ApiError(response.error.toString()));
    }
  }

  Future<Either<ApiError, Map<int, String>>> getOpeningHours() async {
    final response = await _api.apiShiftsShortKeyGet(shortKey: 'analog');

    if (response.isSuccessful) {
      final content = response.body!..sortBy((dto) => dto.start);

      final openingHoursPerWeekday =
          groupBy<OpeningHoursDTO, int>(content, (dto) => dto.start.weekday);

      /*
        create map associating each weekday to its opening hours:
        { 
          0: 8 - 16,
          1: 8 - 16, ... 
        }
      */
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

      return Right(weekDayOpeningHours);
    } else {
      return Left(ApiError(response.error.toString()));
    }
  }
}
