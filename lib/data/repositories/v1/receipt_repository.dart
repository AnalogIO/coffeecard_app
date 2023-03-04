import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:dartz/dartz.dart';

class ReceiptRepository {
  ReceiptRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final Executor executor;

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<Either<RequestFailure, List<Receipt>>> getUserReceipts() async {
    Iterable<Receipt> usedTickets;
    Iterable<Receipt> purchasedTickets;

    try {
      final result = await executor(
        () => apiV1.apiV1TicketsGet(used: true),
      );

      usedTickets = result!.map(Receipt.fromTicketDTO);
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }

    try {
      final result = await executor(
        apiV1.apiV1PurchasesGet,
      );

      purchasedTickets = result!.map(Receipt.fromPurchaseDTO);
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }

    final allTickets = [...usedTickets, ...purchasedTickets];
    allTickets.sort((a, b) => b.timeUsed.compareTo(a.timeUsed));
    return Right(allTickets);
  }
}
