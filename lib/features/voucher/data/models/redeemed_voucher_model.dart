import 'package:coffeecard/features/voucher/domain/entities/redeemed_voucher.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';

class RedeemedVoucherModel extends RedeemedVoucher {
  const RedeemedVoucherModel({
    required super.numberOfTickets,
    required super.productName,
  });

  factory RedeemedVoucherModel.fromDTO(PurchaseDto dto) {
    return RedeemedVoucherModel(
      numberOfTickets: dto.numberOfTickets,
      productName: dto.productName,
    );
  }
}
