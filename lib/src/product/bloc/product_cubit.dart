import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;

  ProductCubit({required this.productRepository})
      : super(const ProductsLoading());

  Future<void> getProducts() => productRepository
      .getProducts()
      .match(ProductsError.new, ProductsLoaded.new)
      .map(emit)
      .run();
}
