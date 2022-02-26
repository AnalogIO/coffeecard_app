import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/ticket/product_count.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

class TicketRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  TicketRepository(this._api, this._logger);

  Future<Either<ApiError, List<TicketCount>>> getUserTickets() async {
    final response = await _api.apiV1TicketsGet(used: false);

    if (response.isSuccessful) {
      final ticketCount = response.body!
          //Groups all products by their id, and returns the amount of products for each id, and their name
          .groupListsBy((t) => t.productName)
          .entries
          .map(
            (e) => TicketCount(
              productName: e.key!,
              count: e.value.length,
              productId: 1, //TODO add actual id, once the backend returns this
            ),
          )
          .toList();
      return Right(ticketCount);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }
}
