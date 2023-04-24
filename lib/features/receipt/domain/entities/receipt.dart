import 'package:equatable/equatable.dart';

/// A receipt for either a used ticket, or a purchase
abstract class Receipt extends Equatable {
  final String productName;
  final DateTime timeUsed;
  final int id;

  const Receipt({
    required this.productName,
    required this.timeUsed,
    required this.id,
  });

  @override
  List<Object?> get props => [productName, timeUsed, id];
}
