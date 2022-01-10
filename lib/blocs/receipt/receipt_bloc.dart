import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/data/repositories/receipt_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'receipt_event.dart';

part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final ReceiptRepository repository;

  ReceiptBloc({required this.repository})
      : super(const ReceiptInitial(DropDownOptions.swipesAndPurchases)) {
    on<ReloadReceipts>(_onReloadReceipts);
    on<DisplayPurchases>(_onDisplayPurchases);
    on<DisplayUsedTicket>(_onDisplayUsedTicket);
    on<DisplayAll>(_onDisplayAll);
  }

  Future<void> _onReloadReceipts(
      ReloadReceipts event, Emitter<ReceiptState> emit) async {
    emit(ReceiptLoading(state.index));
    final receipts = await repository.getUserReceipts();
    _filterReceiptsToDisplay(receipts, emit);
  }

  void _onDisplayPurchases(DisplayPurchases event, Emitter<ReceiptState> emit) {
    const newIndex = DropDownOptions.purchases;
    final oldState = state as ReceiptLoaded;

    emit(const ReceiptLoading(newIndex));

    _filterReceiptsToDisplay(oldState.receiptsCached, emit);
  }

  void _onDisplayUsedTicket(
      DisplayUsedTicket event, Emitter<ReceiptState> emit) {
    const newIndex = DropDownOptions.swipes;
    final oldState = state as ReceiptLoaded;

    emit(const ReceiptLoading(newIndex));

    _filterReceiptsToDisplay(oldState.receiptsCached, emit);
  }

  void _onDisplayAll(DisplayAll event, Emitter<ReceiptState> emit) {
    const newIndex = DropDownOptions.swipesAndPurchases;
    final oldState = state as ReceiptLoaded;

    emit(const ReceiptLoading(newIndex));

    _filterReceiptsToDisplay(oldState.receiptsCached, emit);
  }

  void _filterReceiptsToDisplay(
      List<Receipt> receipts, Emitter<ReceiptState> emit) {
    final List<Receipt> _receipts;
    switch (state.index) {
      case DropDownOptions.swipesAndPurchases:
        _receipts = receipts;
        break;

      case DropDownOptions.swipes:
        _receipts = receipts
            .where((element) =>
                element.transactionType == TransactionType.ticketSwipe)
            .toList();
        break;

      case DropDownOptions.purchases:
        _receipts = receipts
            .where((element) =>
                element.transactionType == TransactionType.purchase)
            .toList();
        break;
    }

    emit(ReceiptLoaded(
        receiptsCached: receipts,
        receiptsForDisplay: _receipts,
        index: state.index));
  }
}
