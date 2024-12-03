import 'package:coffeecard/features/product/product_model.dart';
import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  const Ticket({
    required this.product,
    required this.amountLeft,
  });

  const Ticket.empty()
      : product = const Product.empty(),
        amountLeft = 0;

  final Product product;
  final int amountLeft;

  Ticket copyWith({Product? product, int? amountLeft}) {
    return Ticket(
      product: product ?? this.product,
      amountLeft: amountLeft ?? this.amountLeft,
    );
  }

  @override
  List<Object?> get props => [product, amountLeft];
}
