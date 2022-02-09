import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:logger/logger.dart';

class StatisticsRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  StatisticsRepository(this._api, this._logger);
}
