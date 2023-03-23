import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/executor.dart';

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
  final Executor executor;

  Future<Either<ServerFailure, List<TicketCount>>> getUserTickets() async {
    final result = await executor(
      () => apiV2.apiV2TicketsGet(includeUsed: false),
    );

    return result.map(
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

  Future<Either<ServerFailure, Receipt>> useTicket(int productId) async {
    final result = await executor(
      () => apiV1.apiV1TicketsUsePost(
        body: UseTicketDTO(productId: productId),
      ),
    );

    return result.map(
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
