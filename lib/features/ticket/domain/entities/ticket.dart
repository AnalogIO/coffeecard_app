import 'package:coffeecard/features/product/menu_item_model.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class Ticket extends Equatable {
  const Ticket({
    required this.product,
    required this.amountLeft,
    required this.lastUsedMenuItem,
  });

  const Ticket.empty()
      : product = const Product.empty(),
        amountLeft = 0,
        lastUsedMenuItem = const None();

  final Product product;
  final int amountLeft;
  final Option<MenuItem> lastUsedMenuItem;

  Ticket copyWith({
    Product? product,
    int? amountLeft,
    Option<MenuItem>? lastUsedMenuItem,
  }) {
    return Ticket(
      product: product ?? this.product,
      amountLeft: amountLeft ?? this.amountLeft,
      lastUsedMenuItem: lastUsedMenuItem ?? this.lastUsedMenuItem,
    );
  }

  @override
  List<Object?> get props => [product, amountLeft, lastUsedMenuItem];
}
