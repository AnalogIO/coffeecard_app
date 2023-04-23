import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

class ReceiptModel extends Receipt {
  const ReceiptModel({
    required super.productName,
    required super.transactionType,
    required super.timeUsed,
    required super.price,
    required super.amountPurchased,
    required super.id,
  });

  /// Creates a receipt from a used ticket DTO
  factory ReceiptModel.fromTicketDto(TicketDto dto) {
    return ReceiptModel(
      productName: dto.productName,
      transactionType: TransactionType.ticketSwipe,
      timeUsed: dto
          .dateUsed!, // will not be null as the dto is a ticket that has been used at some point
      price: 1,
      amountPurchased: 1,
      id: dto.id,
    );
  }

  /// Creates a receipt from a used ticket DTO
  factory ReceiptModel.fromTicketResponse(TicketResponse dto) {
    return ReceiptModel(
      productName: dto.productName,
      transactionType: TransactionType.ticketSwipe,
      timeUsed: dto
          .dateUsed!, // will not be null as the dto is a ticket that has been used at some point
      price: 1,
      amountPurchased: 1,
      id: dto.id,
    );
  }

  /// Creates a receipt from a purchase DTO
  factory ReceiptModel.fromSimplePurchaseResponse(
    SimplePurchaseResponse dto,
  ) {
    return ReceiptModel(
      productName: dto.productName,
      transactionType: TransactionType.purchase,
      timeUsed: dto.dateCreated,
      price: dto.totalAmount,
      amountPurchased: dto.numberOfTickets,
      id: dto.id,
    );
  }
}
