import 'package:coffeecard/features/voucher_code.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';

class RedeemedVoucherModel extends RedeemedVoucher {
  const RedeemedVoucherModel({
    required super.numberOfTickets,
    required super.productName,
  });

  factory RedeemedVoucherModel.fromDTO(SimplePurchaseResponse dto) {
    return RedeemedVoucherModel(
      numberOfTickets: dto.numberOfTickets,
      productName: dto.productName,
    );
  }
}
