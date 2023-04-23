import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/receipt/domain/entities/purchase_receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/swipe_receipt.dart';
import 'package:coffeecard/features/receipt/domain/usecases/get_receipts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  final GetReceipts getReceipts;

  ReceiptCubit({required this.getReceipts}) : super(ReceiptState());

  Future<void> fetchReceipts() async {
    final either = await getReceipts(NoParams());

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
          filteredReceipts: filter(receipts, state.filterBy),
        ),
      ),
    );
  }

  void filterReceipts(ReceiptFilterCategory filterBy) {
    if (filterBy == state.filterBy) return;
    emit(
      state.copyWith(
        filterBy: filterBy,
        filteredReceipts: filter(state.receipts, filterBy),
      ),
    );
  }

  // Should only have side effects, move to use case or repository layer
  List<Receipt> filter(
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
