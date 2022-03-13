import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'buy_tickets_state.dart';

enum FilterCategory { clipCards, singleTickets }

class BuyTicketsCubit extends Cubit<BuyTicketsState> {
  final ProductRepository _repository;

  BuyTicketsCubit(this._repository) : super(const BuyTicketsLoading());

  Future<void> getTickets() async {
    emit(const BuyTicketsLoading());
    final response = await _repository.getProducts();

    if (response is Left) {
      emit(BuyTicketsError(response.left.errorMessage));
    } else {
      final List<ProductDto> tickets = response.right;
      emit(BuyTicketsLoaded(tickets));
    }
  }

  Future<void> getFilteredProducts(FilterCategory filterCategory) async {
    if (state is BuyTicketsLoaded) {
      final products = (state as BuyTicketsLoaded).products;
      List<ProductDto> filteredProducts;
      if (filterCategory == FilterCategory.clipCards) {
        filteredProducts =
            products.where((p) => p.numberOfTickets != 1).toList();
      } else if (filterCategory == FilterCategory.singleTickets) {
        filteredProducts =
            products.where((p) => p.numberOfTickets == 1).toList();
      } else {
        filteredProducts = [];
      }

      emit(BuyTicketsFiltered(products, filteredProducts));
    }
  }
}
