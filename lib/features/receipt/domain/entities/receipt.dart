import 'package:coffeecard/base/strings.dart';
import 'package:equatable/equatable.dart';

part 'placeholder_receipt.dart';
part 'purchase_receipt.dart';
part 'swipe_receipt.dart';

/// A receipt for either a used ticket, or a purchase
sealed class Receipt extends Equatable {
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
