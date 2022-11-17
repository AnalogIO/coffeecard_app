import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/utils/either.dart';

class ReceiptRepository {
  ReceiptRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final Executor executor;

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<Either<RequestError, Iterable<Receipt>>> getUserReceipts() async {
    final usedTicketsFutureEither = executor.execute(
      () => apiV1.apiV1TicketsGet(used: true),
      transformer: (dto) => dto.map(Receipt.fromTicketDTO),
    );
    final purchasedTicketsFutureEither = executor.execute(
      apiV1.apiV1PurchasesGet,
      transformer: (dto) => dto.map(Receipt.fromPurchaseDTO),
    );

    final usedTicketsEither = await usedTicketsFutureEither;
    final purchasedTicketsEither = await purchasedTicketsFutureEither;

    if (usedTicketsEither.isLeft) {
      return Left(usedTicketsEither.left);
    } else if (purchasedTicketsEither.isLeft) {
      return Left(purchasedTicketsEither.left);
    } else {
      final usedTickets = usedTicketsEither.right;
      final purchasedTickets = purchasedTicketsEither.right;
      final allTickets = [...usedTickets, ...purchasedTickets];
      allTickets.sort((a, b) => b.timeUsed.compareTo(a.timeUsed));
      return Right(allTickets);
    }
  }
}
