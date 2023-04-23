import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:coffeecard/features/receipt/domain/entities/purchase_receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/swipe_receipt.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  final ReceiptRemoteDataSource _repository;

  ReceiptCubit(this._repository) : super(ReceiptState());

  Future<void> fetchReceipts() async {
    final either = await _repository.getUserReceipts();

    either.fold(
      (error) => emit(
        state.copyWith(
          status: ReceiptStatus.failure,
          error: error.reason,
        ),
      ),
      (receipts) => emit(
        state.copyWith(
          status: ReceiptStatus.success,
          receipts: receipts,
          filteredReceipts: _filter(receipts, state.filterBy),
        ),
      ),
    );
  }

  void filterReceipts(ReceiptFilterCategory filterBy) {
    if (filterBy == state.filterBy) return;
    emit(
      state.copyWith(
        filterBy: filterBy,
        filteredReceipts: _filter(state.receipts, filterBy),
      ),
    );
  }

  List<Receipt> _filter(
    List<Receipt> receipts,
    ReceiptFilterCategory filterBy,
  ) {
    switch (filterBy) {
      case ReceiptFilterCategory.all:
        return receipts;
      case ReceiptFilterCategory.swipes:
        return receipts.whereType<SwipeReceipt>().toList();
      case ReceiptFilterCategory.purchases:
        return receipts.whereType<PurchaseReceipt>().toList();
    }
  }
}
