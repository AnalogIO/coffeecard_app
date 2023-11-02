import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/product/domain/entities/purchasable_products.dart';
import 'package:coffeecard/features/product/domain/usecases/get_all_products.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProducts getAllProducts;

  ProductCubit({required this.getAllProducts}) : super(const ProductsLoading());

  Future<void> getProducts() async {
    emit(const ProductsLoading());
    final result = await getAllProducts();
    emit(result.fold(ProductsError.fromFailure, ProductsLoaded.new));
  }
}
