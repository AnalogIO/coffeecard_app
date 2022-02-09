import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class ReceiptRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ReceiptRepository(this._api, this._logger);

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<Either<ApiError, List<Receipt>>> getUserReceipts() async {
    final usedTicketResponse = await _api.apiV1TicketsGet(used: true);
    final purchaseResponse = await _api.apiV1PurchasesGet();

    Iterable<Receipt> ticketReceipts = [];
    Iterable<Receipt> purchaseReceipts = [];

    if (usedTicketResponse.isSuccessful) {
      ticketReceipts = usedTicketResponse.body!.map(
        (ticket) => Receipt(
          productName: ticket.productName!,
          transactionType: TransactionType.ticketSwipe,
          price: 1,
          amountPurchased: 1,
          timeUsed: ticket.dateUsed!,
          id: ticket.id!,
        ),
      );
    } else {
      _logger.e(
        'API Error ${usedTicketResponse.statusCode} ${usedTicketResponse.error}',
      );
      return Left(ApiError(usedTicketResponse.error.toString()));
    }

    if (purchaseResponse.isSuccessful) {
      purchaseReceipts = purchaseResponse.body!.map(
        (purchase) => Receipt(
          productName: purchase.productName!,
          transactionType: TransactionType.purchase,
          price: purchase.price!,
          amountPurchased: purchase.numberOfTickets!,
          timeUsed: purchase.dateCreated!,
          id: purchase.id!,
        ),
      );
    } else {
      _logger.e(
        'API Error ${purchaseResponse.statusCode} ${purchaseResponse.error}',
      );
      return Left(ApiError(purchaseResponse.error.toString()));
    }

    return Right(
      ticketReceipts.followedBy(purchaseReceipts).toList()
        ..sort(
          (receipt, receipt1) => receipt.timeUsed.compareTo(receipt1.timeUsed),
        ),
    );
  }
}
