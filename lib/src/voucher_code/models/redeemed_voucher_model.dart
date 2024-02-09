import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:equatable/equatable.dart';

class RedeemedVoucher extends Equatable {
  const RedeemedVoucher({
    required this.numberOfTickets,
    required this.productName,
  });

  factory RedeemedVoucher.fromDTO(SimplePurchaseResponse dto) {
    return RedeemedVoucher(
      numberOfTickets: dto.numberOfTickets,
      productName: dto.productName,
    );
  }

  final int numberOfTickets;
  final String productName;

  @override
  List<Object?> get props => [numberOfTickets, productName];
}
