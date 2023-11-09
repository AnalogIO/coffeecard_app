import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final int amount;
  final int price;
  final String name;
  final String description;
  final bool isPerk;

  const Product({
    required this.id,
    required this.amount,
    required this.price,
    required this.name,
    required this.description,
    required this.isPerk,
  });

  @override
  List<Object?> get props => [id, amount, price, name, description, isPerk];
}
