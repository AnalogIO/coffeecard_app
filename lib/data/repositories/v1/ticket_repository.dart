import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/ticket_count.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

class TicketRepository {
  TicketRepository({
    required this.apiV1,
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  Future<Either<NetworkFailure, List<TicketCount>>> getUserTickets() async {
    return executor(
      () => apiV2.apiV2TicketsGet(includeUsed: false),
    ).bindFuture(
      (result) => result
          .groupListsBy((t) => t.productName)
          .entries
          .map(
            (t) => TicketCount(
              count: t.value.length,
              productName: t.key,
              productId: t.value.first.productId,
            ),
          )
          .sortedBy<num>((t) => t.productId)
          .toList(),
    );
  }

  Future<Either<NetworkFailure, Receipt>> useTicket(int productId) async {
    return executor(
      () => apiV1.apiV1TicketsUsePost(
        body: UseTicketDTO(productId: productId),
      ),
    ).bindFuture(
      (result) => Receipt(
        productName: result.productName,
        id: result.id,
        transactionType: TransactionType.ticketSwipe,
        timeUsed: result.dateUsed,
        // TODO(fremartini): Find a better alternative to these default values They are unused on the receipt overlay, https://github.com/AnalogIO/coffeecard_app/issues/384
        amountPurchased: -1,
        price: -1,
      ),
    );
  }
}
