import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

class SwipeReceiptModel extends SwipeReceipt {
  const SwipeReceiptModel({
    required super.productName,
    required super.timeUsed,
    required super.id,
    required super.menuItemName,
  });

  factory SwipeReceiptModel.fromUsedTicketResponse(UsedTicketResponse dto) {
    return SwipeReceiptModel(
      productName: dto.productName,
      timeUsed: dto.dateUsed,
      id: dto.id,
      menuItemName: dto.menuItemName ?? 'some ${dto.productName}',
    );
  }

  factory SwipeReceiptModel.fromTicketResponse(TicketResponse dto) {
    return SwipeReceiptModel(
      productName: dto.productName,
      timeUsed: dto
          .dateUsed!, // will not be null as the dto is a ticket that has been used at some point
      id: dto.id,
      menuItemName: dto.usedOnMenuItemName ?? 'some ${dto.productName}',
    );
  }
}
