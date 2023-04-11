import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';

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
  Receipt.fromTicketDTO(TicketDto dto)
      : productName = dto.productName,
        transactionType = TransactionType.ticketSwipe,
        timeUsed = dto.dateUsed!,
        price = 1,
        amountPurchased = 1,
        id = dto.id;

  /// Creates a receipt from a purchase DTO
  Receipt.fromPurchaseDTO(PurchaseDto dto)
      : productName = dto.productName,
        transactionType = TransactionType.purchase,
        timeUsed = dto.dateCreated,
        price = dto.price,
        amountPurchased = dto.numberOfTickets,
        id = dto.id;
}
