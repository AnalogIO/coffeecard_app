import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class TicketRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  TicketRepository(this._api, this._logger);

  Future<Either<ApiError, List<TicketDto>>> getUserTickets() async {
    final response = await _api.apiV1TicketsGet(used: false);

    if (response.isSuccessful) {
      return Right(response.body!);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }
}
