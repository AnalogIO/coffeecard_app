import 'package:coffeecard/features/receipt/domain/entities/swipe_receipt.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

class SwipeReceiptModel extends SwipeReceipt {
  const SwipeReceiptModel({
    required super.productName,
    required super.timeUsed,
    required super.id,
  });

  /// Creates a receipt from a used ticket DTO
  factory SwipeReceiptModel.fromTicketDto(TicketDto dto) {
    return SwipeReceiptModel(
      productName: dto.productName,
      timeUsed: dto
          .dateUsed!, // will not be null as the dto is a ticket that has been used at some point
      id: dto.id,
    );
  }

  /// Creates a receipt from a used ticket DTO
  factory SwipeReceiptModel.fromTicketResponse(TicketResponse dto) {
    return SwipeReceiptModel(
      productName: dto.productName,
      timeUsed: dto
          .dateUsed!, // will not be null as the dto is a ticket that has been used at some point
      id: dto.id,
    );
  }
}
