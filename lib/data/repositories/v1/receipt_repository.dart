import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:dartz/dartz.dart';

class ReceiptRepository {
  ReceiptRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final NetworkRequestExecutor executor;

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<Either<NetworkFailure, List<Receipt>>> getUserReceipts() async {
    final usedTicketsEither = await executor(
      () => apiV1.apiV1TicketsGet(used: true),
    );

    final purchasedTicketsEither = await executor(
      apiV1.apiV1PurchasesGet,
    );

    return usedTicketsEither.bind(
      (usedTickets) => purchasedTicketsEither.map(
        (purchasedTickets) {
          final allTickets = [
            ...usedTickets.map(Receipt.fromTicketDTO),
            ...purchasedTickets.map(Receipt.fromPurchaseDTO),
          ];
          allTickets.sort((a, b) => b.timeUsed.compareTo(a.timeUsed));
          return allTickets;
        },
      ),
    );
  }
}
