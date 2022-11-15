import 'package:chopper/chopper.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class ReceiptRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ReceiptRepository(this._api, this._logger);

  /// Retrieves all of the users receipts
  /// This includes both their used tickets and purchased tickets
  Future<Either<RequestError, List<Receipt>>> getUserReceipts() async {
    final Future<Response<List<TicketDto>>> usedTicketRequest;
    final Future<Response<List<PurchaseDto>>> purchaseRequest;
    try {
      usedTicketRequest = _api.apiV1TicketsGet(used: true);
      purchaseRequest = _api.apiV1PurchasesGet();
    } catch (e) {
      return Left(ClientNetworkError());
    }

    final usedTicketResponse = await usedTicketRequest;
    final purchaseResponse = await purchaseRequest;

    Iterable<Receipt> ticketReceipts = [];
    Iterable<Receipt> purchaseReceipts = [];

    if (usedTicketResponse.isSuccessful) {
      ticketReceipts = usedTicketResponse.body!.map(
        (ticket) => Receipt(
          productName: ticket.productName,
          transactionType: TransactionType.ticketSwipe,
          price: 1,
          amountPurchased: 1,
          timeUsed: ticket.dateUsed,
          id: ticket.id,
        ),
      );
    } else {
      _logger.e(
        usedTicketResponse.formatError(),
      );
      return Left(
        RequestError(
          usedTicketResponse.error.toString(),
          usedTicketResponse.statusCode,
        ),
      );
    }

    if (purchaseResponse.isSuccessful) {
      purchaseReceipts = purchaseResponse.body!.map(
        (purchase) => Receipt(
          productName: purchase.productName,
          transactionType: TransactionType.purchase,
          price: purchase.price,
          amountPurchased: purchase.numberOfTickets,
          timeUsed: purchase.dateCreated,
          id: purchase.id,
        ),
      );
    } else {
      _logger.e(
        purchaseResponse.formatError(),
      );
      return Left(
        RequestError(
          purchaseResponse.error.toString(),
          purchaseResponse.statusCode,
        ),
      );
    }

    return Right(
      ticketReceipts.followedBy(purchaseReceipts).toList()
        ..sort(
          (receipt, receipt1) => receipt1.timeUsed.compareTo(receipt.timeUsed),
        ),
    );
  }
}
