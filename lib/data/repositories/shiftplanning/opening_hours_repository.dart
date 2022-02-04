import 'package:coffeecard/generated/api/shiftplanning_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:logger/logger.dart';

class OpeningHoursRepository {
  final ShiftplanningApi _api;
  final Logger _logger;

  OpeningHoursRepository(this._api, this._logger);

  Future<bool> isOpen() async {
    final response = await _api.apiOpenShortKeyGet(
      shortKey: 'analog',
    );

    if (response.isSuccessful) {
      return response.body!.open!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }
}
