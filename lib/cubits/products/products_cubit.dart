import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository _repository;

  ProductsCubit(this._repository) : super(const ProductsLoading());

  Future<void> getProducts() async {
    emit(const ProductsLoading());
    final response = await _repository.getProducts();

    if (response.isRight) {
      final ticketProducts = response.right.where((p) => p.amount > 1);
      final singleDrinkProducts = response.right.where((p) => p.amount == 1);
      emit(
        ProductsLoaded(
          ticketProducts.toList(),
          singleDrinkProducts.toList(),
        ),
      );
    } else {
      emit(ProductsError(response.left.message));
    }
  }
}
