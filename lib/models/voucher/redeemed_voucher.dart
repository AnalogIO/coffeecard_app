import 'package:equatable/equatable.dart';

class RedeemedVoucher extends Equatable {
  final int numberOfTickets;
  final String productName;

  const RedeemedVoucher({
    required this.numberOfTickets,
    required this.productName,
  });

  @override
  List<Object?> get props => [numberOfTickets, productName];
}
