import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:logger/logger.dart';

class TicketRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  TicketRepository(this._api, this._logger);

  Future<List<TicketDto>> getUserTickets() async {
    final response = await _api.apiV1TicketsGet(used: false);

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }
}
