import 'package:coffeecard/features/product/menu_item_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Product extends Equatable {
  const Product({
    required this.price,
    required this.amount,
    required this.name,
    required this.id,
    required this.description,
    required this.isPerk,
    required this.eligibleMenuItems,
  });

  const Product.empty()
      : price = 0,
        amount = 0,
        name = '',
        id = 0,
        description = '',
        isPerk = false,
        eligibleMenuItems = const [];

  factory Product.fromResponse(ProductResponse response) {
    final eligibleMenuItems =
        // convert to non-nullable list with an empty list as default
        // (eligibleMenuItems is nullable in the response
        // for backwards compatibility reasons)
        Option.fromNullable(response.eligibleMenuItems)
            .getOrElse(() => [])
            .map(MenuItem.fromResponse)
            .toList();

    return Product(
      price: response.price,
      amount: response.numberOfTickets,
      name: response.name,
      id: response.id,
      description: response.description,
      isPerk: response.isPerk,
      eligibleMenuItems: eligibleMenuItems,
    );
  }

  final int id;
  final int amount;
  final int price;
  final String name;
  final String description;
  final bool isPerk;
  final List<MenuItem> eligibleMenuItems;

  /// The name of the Hive box used to store the last used menu item.
  static const _hiveBoxName = 'lastUsedMenuItemByProductId';

  /// Returns the last used menu item for this product as a [TaskOption].
  TaskOption<MenuItem> get lastUsedMenuItem {
    return TaskOption(() async {
      final cache = await Hive.openBox<int>(_hiveBoxName);
      final lastUsedMenuItemIdFromCache = cache.get(id);
      return Option.fromNullable(
        eligibleMenuItems.firstWhereOrNull(
          (item) => item.id == lastUsedMenuItemIdFromCache,
        ),
      );
    });
  }

  /// Updates the last used menu item for this product.
  Task<Unit> updateLastUsedMenuItem(MenuItem menuItem) {
    return Task(() async {
      final cache = await Hive.openBox<int>(_hiveBoxName);
      await cache.put(id, menuItem.id);
      return unit;
    });
  }

  Product copyWith({
    int? price,
    int? amount,
    String? name,
    int? id,
    String? description,
    bool? isPerk,
    List<MenuItem>? eligibleMenuItems,
  }) {
    return Product(
      price: price ?? this.price,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      id: id ?? this.id,
      description: description ?? this.description,
      isPerk: isPerk ?? this.isPerk,
      eligibleMenuItems: eligibleMenuItems ?? this.eligibleMenuItems,
    );
  }

  @override
  List<Object?> get props => [id, amount, price, name, description, isPerk];
}
