import 'package:equatable/equatable.dart';

class TicketCount extends Equatable {
  final int productId;
  final int count;
  final String productName;
  final bool isBaristaTicket;

  const TicketCount({
    required this.count,
    required this.productName,
    required this.productId,
    required this.isBaristaTicket,
  });

  @override
  String toString() {
    return 'ProductCount{count: $count, productName: $productName}';
  }

  @override
  List<Object?> get props => [productId, count, productName, isBaristaTicket];
}
