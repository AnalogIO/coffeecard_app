import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:logger/logger.dart';

class ReceiptRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ReceiptRepository(this._api, this._logger);

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<List<Receipt>> getUserReceipts() async {
    final usedTicketRequest = _api.apiV1TicketsGet(used: true);
    final purchasesRequest = _api.apiV1PurchasesGet();

    final usedTicketResponse = await usedTicketRequest;
    final purchaseResponse = await purchasesRequest;

    if (!usedTicketResponse.isSuccessful) {
      _logger.e(
        'API Error ${usedTicketResponse.statusCode} ${usedTicketResponse.error}',
      );
    }
    if (!purchaseResponse.isSuccessful) {
      _logger.e(
        'API Error ${purchaseResponse.statusCode} ${purchaseResponse.error}',
      );
    }

    final ticketReceipts = usedTicketResponse.body?.map(
      (ticket) => Receipt(
        //TODO consider if better defaults can be provided. Ideally the user never encounters this, since it would imply our database is incomplete
        productName: ticket.productName!,
        transactionType: TransactionType.ticketSwipe,
        price: 1,
        amountPurchased: 1,
        timeUsed: ticket.dateUsed!,
        id: ticket.id!,
      ),
    );

    final purchaseReceipts = purchaseResponse.body?.map(
      (purchase) => Receipt(
        //TODO consider if better defaults can be provided. Ideally the user never encounters this, since it would imply our database is incomplete
        productName: purchase.productName!,
        transactionType: TransactionType.purchase,
        price: purchase.price!,
        amountPurchased: purchase.numberOfTickets!,
        timeUsed: purchase.dateCreated!,
        id: purchase.id!,
      ),
    );

    final sortedReceipts = ticketReceipts!
        .followedBy(purchaseReceipts!)
        .toList()
      ..sort((a, b) => b.timeUsed.compareTo(a.timeUsed));

    return sortedReceipts;
  }
}
