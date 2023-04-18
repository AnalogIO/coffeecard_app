import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:dartz/dartz.dart';

class ReceiptRepository {
  ReceiptRepository({
    required this.productRepository,
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final ProductRepository productRepository;
  final NetworkRequestExecutor executor;

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<Either<Failure, List<Receipt>>> getUserReceipts() async {
    final usedTicketsFutureEither = executor(
      () => apiV2.apiV2TicketsGet(includeUsed: true),
    );
    // The API CAN return null if the user has no tickets,
    // but the generator doesn't pick up on this, hence the type parameter
    final purchasedTicketsFutureEither =
        executor<List<SimplePurchaseResponse>?>(
      apiV2.apiV2PurchasesGet,
    );

    final usedTicketsEither = (await usedTicketsFutureEither)
        .map((dto) => dto.map(Receipt.fromTicketResponse));
    final purchasedTicketsEither = (await purchasedTicketsFutureEither).map(
      (simplePurchases) {
        // If the user has no purchases, the API returns 204 No Content (body is
        // null). The generator is bad and doesn't handle this case
        if (simplePurchases == null) return List<Receipt>.empty();
        return simplePurchases.map(Receipt.fromSimplePurchaseResponse);
      },
    );

    return usedTicketsEither.fold(
      (l) => Left(l),
      (usedTickets) => purchasedTicketsEither.map(
        (purchasedTickets) {
          final allTickets = [...usedTickets, ...purchasedTickets];
          allTickets.sort((a, b) => b.timeUsed.compareTo(a.timeUsed));
          return allTickets;
        },
      ),
    );
  }
}
