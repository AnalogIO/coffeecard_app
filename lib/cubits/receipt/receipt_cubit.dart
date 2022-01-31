import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/receipt_repository.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  final ReceiptRepository _repository;

  ReceiptCubit(this._repository) : super(ReceiptState());

  Future<void> fetchReceipts(/*String? latestReciept*/) async {
    final receipts = await _repository.getUserReceipts();
    emit(
      state.copyWith(
        status: ReceiptStatus.success,
        receipts: receipts,
        filteredReceipts: _filter(receipts, state.filterBy),
      ),
    );
  }

  void filterReceipts(FilterCategory filterBy) {
    if (filterBy == state.filterBy) return;
    emit(
      state.copyWith(
        filterBy: filterBy,
        filteredReceipts: _filter(state.receipts, filterBy),
      ),
    );
  }

  List<Receipt> _filter(List<Receipt> receipts, FilterCategory filterBy) {
    switch (filterBy) {
      case FilterCategory.all:
        return receipts;
      case FilterCategory.swipes:
        return receipts
            .where((r) => r.transactionType == TransactionType.ticketSwipe)
            .toList();
      case FilterCategory.purchases:
        return receipts
            .where((r) => r.transactionType == TransactionType.purchase)
            .toList();
      default:
        throw Exception('Unknown filter category: $filterBy');
    }
  }
}
