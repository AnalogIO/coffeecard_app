import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:dartz/dartz.dart';

class ReceiptRepository {
  ReceiptRepository({
    required this.productRepository,
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final ProductRepository productRepository;
  final Executor executor;

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<Either<RequestFailure, List<Receipt>>> getUserReceipts() async {
    final productsEither = await productRepository.getProducts();

    var productMap = <int, Product>{};
    productsEither.map((products) =>
        productMap = {for (var product in products) product.id: product});

    if (productsEither.isLeft()) {
      return Left(
          (productsEither as Left<RequestFailure, List<Product>>).value);
    }

    final usedTicketsFutureEither = executor.execute(
      () => apiV2.apiV2TicketsGet(includeUsed: true),
      (dto) => dto.map(Receipt.fromTicketResponse),
    );

    final purchasedTicketsFutureEither = executor.execute(
      apiV2.apiV2PurchasesGet,
      (dto) => dto.map(
        (purchase) => Receipt.fromSimplePurchaseResponse(
          purchase,
          productMap.containsKey(purchase.productId)
              ? productMap[purchase.productId]!
              : const Product(
                  price: 0,
                  amount: 0,
                  name: 'Unknown product',
                  id: 0,
                  description:
                      'We could not find this product in our database'), // Fixme better default
        ),
      ),
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
