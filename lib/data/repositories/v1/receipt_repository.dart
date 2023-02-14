import 'package:coffeecard/data/repositories/utils/executor.dart';
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
    final usedTicketsFutureEither = executor.execute(
      () => apiV1.apiV1TicketsGet(used: true),
      (dto) => dto.map(Receipt.fromTicketDTO),
    );
    final purchasedTicketsFutureEither = executor.execute(
      apiV1.apiV1PurchasesGet,
      (dto) => dto.map(Receipt.fromPurchaseDTO),
    );

    final usedTicketsEither = await usedTicketsFutureEither;

    return usedTicketsEither.fold(
      (l) => Left(l),
      (usedTickets) async {
        final purchasedTicketsEither = await purchasedTicketsFutureEither;

        return purchasedTicketsEither.fold(
          (l) => Left(l),
          (purchasedTickets) {
            final allTickets = [...usedTickets, ...purchasedTickets];
            allTickets.sort((a, b) => b.timeUsed.compareTo(a.timeUsed));
            return Right(allTickets);
          },
        );
      },
    );
  }
}
