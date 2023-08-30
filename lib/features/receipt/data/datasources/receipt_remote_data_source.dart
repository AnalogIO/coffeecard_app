import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/receipt/data/models/purchase_receipt_model.dart';
import 'package:coffeecard/features/receipt/data/models/swipe_receipt_model.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class ReceiptRemoteDataSource {
  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  ReceiptRemoteDataSource({
    required this.apiV2,
    required this.executor,
  });

  /// Retrieves all of the users used receipts
  Future<Either<Failure, List<Receipt>>> getUsersUsedTicketsReceipts() {
    return executor
        .execute(() => apiV2.apiV2TicketsGet(includeUsed: true))
        .mapAll(SwipeReceiptModel.fromTicketResponse);
  }

  /// Retrieves all of the users purchase receipts
  Future<Either<Failure, List<Receipt>>> getUserPurchasesReceipts() {
    return executor
        .execute(apiV2.apiV2PurchasesGet)
        .mapAll(PurchaseReceiptModel.fromSimplePurchaseResponse);
  }
}
