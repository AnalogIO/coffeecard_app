import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';
import 'package:equatable/equatable.dart';

class RedeemedVoucher extends Equatable {
  final int numberOfTickets;
  final String productName;

  const RedeemedVoucher({
    required this.numberOfTickets,
    required this.productName,
  });

  RedeemedVoucher.fromDTO(PurchaseDto dto)
      : numberOfTickets = dto.numberOfTickets,
        productName = dto.productName;

  @override
  List<Object?> get props => [numberOfTickets, productName];
}
