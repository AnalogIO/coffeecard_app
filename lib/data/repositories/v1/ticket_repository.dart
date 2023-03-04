import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
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

  Future<Either<RequestFailure, List<TicketCount>>> getUserTickets() async {
    try {
      final result = await executor(
        () => apiV2.apiV2TicketsGet(includeUsed: false),
      );

      return Right(
        result!
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
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }

  Future<Either<RequestFailure, Receipt>> useTicket(int productId) async {
    try {
      final result = await executor(
        () => apiV1.apiV1TicketsUsePost(
          body: UseTicketDTO(productId: productId),
        ),
      );

      return Right(
        Receipt(
          productName: result!.productName,
          id: result.id,
          transactionType: TransactionType.ticketSwipe,
          timeUsed: result.dateUsed,
          // TODO(fremartini): Find a better alternative to these default values They are unused on the receipt overlay, https://github.com/AnalogIO/coffeecard_app/issues/384
          amountPurchased: -1,
          price: -1,
        ),
      );
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }
}
