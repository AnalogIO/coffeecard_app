import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/executor.dart';
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
  Future<Either<ServerFailure, List<Receipt>>> getUserReceipts() async {
    final usedTicketsEither = await executor(
      () => apiV1.apiV1TicketsGet(used: true),
    );

    final purchasedTicketsEither = await executor(
      apiV1.apiV1PurchasesGet,
    );

    return usedTicketsEither.fold((l) => Left(l), (r) {
      final usedTickets = r.map(Receipt.fromTicketDTO);

      return purchasedTicketsEither.fold((l) => Left(l), (r) {
        final purchasedTickets = r.map(Receipt.fromPurchaseDTO);

        final allTickets = [...usedTickets, ...purchasedTickets];
        allTickets.sort((a, b) => b.timeUsed.compareTo(a.timeUsed));
        return Right(allTickets);
      });
    });
  }
}
