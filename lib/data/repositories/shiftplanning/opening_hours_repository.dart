import 'package:chopper/chopper.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:coffeecard/models/opening_hours_day.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

class OpeningHoursRepository {
  final ShiftplanningApi _api;
  final Logger _logger;

  OpeningHoursRepository(this._api, this._logger);

  Future<Either<RequestError, bool>> isOpen() async {
    final Response<IsOpenDTO> response;
    try {
      response = await _api.apiOpenShortKeyGet(shortKey: 'analog');
    } catch (e) {
      return Left(ClientNetworkError());
    }

    if (response.isSuccessful) {
      return Right(response.body!.open);
    } else {
      _logger.e(response.formatError());
      throw Left(RequestError(response.error.toString(), response.statusCode));
    }
  }

  Future<Either<RequestError, Map<int, String>>> getOpeningHours() async {
    final Response<List<OpeningHoursDTO>> response;
    try {
      response = await _api.apiShiftsShortKeyGet(shortKey: 'analog');
    } catch (e) {
      return Left(ClientNetworkError());
    }

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
      return Left(RequestError(response.error.toString(), response.statusCode));
    }
  }
}
