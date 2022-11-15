import 'package:chopper/chopper.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/ticket_count.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

class TicketRepository {
  final CoffeecardApi _api;
  final CoffeecardApiV2 _apiV2;
  final Logger _logger;

  TicketRepository(this._api, this._apiV2, this._logger);

  Future<Either<RequestError, List<TicketCount>>> getUserTickets() async {
    final Response<List<TicketResponse>> response;
    try {
      response = await _apiV2.apiV2TicketsGet(includeUsed: false);
    } catch (e) {
      return Left(ClientNetworkError());
    }

    if (response.isSuccessful) {
      final ticketCount = response.body!
          // Groups all products by their id, and returns the amount of products for each id, and their name
          .groupListsBy((t) => t.productName)
          .entries
          .map(
            (e) => TicketCount(
              productName: e.key,
              count: e.value.length,
              productId: e.value.first.productId,
            ),
          )
          .sortedBy<num>((e) => e.productId)
          .toList();
      return Right(ticketCount);
    }
    _logger.e(response.formatError());
    return Left(RequestError(response.error.toString(), response.statusCode));
  }

  Future<Either<RequestError, Receipt>> useTicket(int productId) async {
    final Response<TicketDto> response;
    try {
      response = await _api.apiV1TicketsUsePost(
        body: UseTicketDTO(productId: productId),
      );
    } catch (e) {
      return Left(ClientNetworkError());
    }

    if (response.isSuccessful) {
      final ticketDto = response.body!;
      return Right(
        Receipt(
          productName: ticketDto.productName,
          id: ticketDto.id,
          transactionType: TransactionType.ticketSwipe,
          timeUsed: ticketDto.dateUsed,
          // TODO: Find a better alternative to these default values.
          //  They are unused on the receipt overlay
          amountPurchased: -1,
          price: -1,
        ),
      );
    }
    _logger.e(response.formatError());
    return Left(RequestError(response.error.toString(), response.statusCode));
  }
}
