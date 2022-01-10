import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/account/unauthorized_error.dart';
import 'package:coffeecard/models/http/api_error.dart';
import 'package:coffeecard/persistence/http/coffee_card_api_constants.dart';

import 'package:logger/logger.dart';

class ReceiptRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ReceiptRepository(this._api, this._logger);

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<void> getUserReceipts() async {
    final response = await _api.apiVVersionTicketsGet(used: true, version: CoffeeCardApiConstants.apiVersion);
    if (!response.isSuccessful) {
      _logger.e('API Error ${response.statusCode} ${response.error}');
    throw;
  }
  }
}
