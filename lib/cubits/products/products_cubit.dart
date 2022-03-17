import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository _repository;

  ProductsCubit(this._repository) : super(const ProductsLoading());

  Future<void> getTicketProducts() async {
    emit(const ProductsLoading());
    final response = await _repository.getTicketProducts();

    if (response.isRight) {
      emit(ProductsLoaded(response.right));
    } else {
      emit(ProductsError(response.left.errorMessage));
    }
  }
}
