import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/domain/usecases/get_all_products.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProducts getAllProducts;

  ProductCubit({required this.getAllProducts}) : super(const ProductsLoading());

  Future<void> getProducts() async {
    emit(const ProductsLoading());

    final either = await getAllProducts();

    either.fold(
      (error) => emit(ProductsError(error.reason)),
      (ticketsAndSingleDrinksAndPerks) {
        emit(
          ProductsLoaded(
            clipCards: ticketsAndSingleDrinksAndPerks.$1,
            singleDrinks: ticketsAndSingleDrinksAndPerks.$2,
            perks: ticketsAndSingleDrinksAndPerks.$3,
          ),
        );
      },
    );
  }
}
