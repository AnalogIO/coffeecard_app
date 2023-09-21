import 'package:equatable/equatable.dart';

class TicketCount extends Equatable {
  final int productId;
  final int count;
  final String productName;

  const TicketCount({
    required this.count,
    required this.productName,
    required this.productId,
  });

  @override
  String toString() {
    return 'ProductCount{count: $count, productName: $productName}';
  }

  @override
  List<Object?> get props => [productId, count, productName];
}
