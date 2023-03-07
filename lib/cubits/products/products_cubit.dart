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
    final either = await _repository.getProducts();

    either.fold(
      (error) => emit(ProductsError(error.reason)),
      (products) {
        final ticketProducts = products.where((p) => p.amount > 1);
        final singleDrinkProducts = products.where((p) => p.amount == 1);
        emit(
          ProductsLoaded(
            ticketProducts.toList(),
            singleDrinkProducts.toList(),
          ),
        );
      },
    );
  }
}
