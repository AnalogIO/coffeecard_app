import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
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
      return Right(response.body!.open!);
    } else {
      _logger.e(Strings.formatApiError(response));
      throw Left(ApiError(response.error.toString()));
    }
  }

  String getOpeningHours() {
    //FIXME: fetch data when available
    const String normalOperation = '8 - 16';
    const String closed = 'Closed';

    final Map<int, String> openingHours = {
      DateTime.monday: 'Mondays: $normalOperation',
      DateTime.tuesday: 'Tuesdays: $normalOperation',
      DateTime.wednesday: 'Wednesdays: $normalOperation',
      DateTime.thursday: 'Thursdays: $normalOperation',
      DateTime.friday: 'Fridays: 8 - 14',
      DateTime.saturday: 'Saturdays: $closed',
      DateTime.sunday: 'Sundays: $closed',
    };

    return openingHours[DateTime.now().weekday]!;
  }
}
