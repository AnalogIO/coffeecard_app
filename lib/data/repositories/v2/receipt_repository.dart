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
    final purchasedTicketsFutureEither = executor(
      apiV2.apiV2PurchasesGet,
    );

    final usedTicketsEither = (await usedTicketsFutureEither)
        .map((dto) => dto.map(Receipt.fromTicketResponse));
    final purchasedTicketsEither = (await purchasedTicketsFutureEither).map(
      (r) => r.map(
        (purchase) => Receipt.fromSimplePurchaseResponse(
          purchase,
        ),
      ),
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
