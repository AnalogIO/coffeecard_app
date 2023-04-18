import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

enum TransactionType { purchase, ticketSwipe, placeholder }

/// A receipt for either a used ticket, or a purchase
class Receipt {
  final String productName;
  final TransactionType transactionType;
  final DateTime timeUsed;
  final int price;
  final int amountPurchased;
  final int id;

  Receipt({
    required this.productName,
    required this.transactionType,
    required this.timeUsed,
    required this.price,
    required this.amountPurchased,
    required this.id,
  });

  /// Creates a receipt from a used ticket DTO
  Receipt.fromTicketDto(TicketDto dto)
      : productName = dto.productName,
        transactionType = TransactionType.ticketSwipe,
        timeUsed = dto
            .dateUsed!, // will not be null as the dto is a ticket that has been used at some point
        price = 1,
        amountPurchased = 1,
        id = dto.id;

  /// Creates a receipt from a used ticket DTO
  Receipt.fromTicketResponse(TicketResponse dto)
      : productName = dto.productName,
        transactionType = TransactionType.ticketSwipe,
        timeUsed = dto
            .dateUsed!, // will not be null as the dto is a ticket that has been used at some point
        price = 1,
        amountPurchased = 1,
        id = dto.id;

  /// Creates a receipt from a purchase DTO
  Receipt.fromSimplePurchaseResponse(
    SimplePurchaseResponse dto,
  )   : productName = dto.productName,
        transactionType = TransactionType.purchase,
        timeUsed = dto.dateCreated,
        price = dto.totalAmount,
        amountPurchased = dto.numberOfTickets,
        id = dto.id;
}
