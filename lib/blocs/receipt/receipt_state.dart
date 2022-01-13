part of 'receipt_bloc.dart';

enum DropDownOptions { swipesAndPurchases, swipes, purchases }

abstract class ReceiptState extends Equatable {
  Map<DropDownOptions, String> get dropDownOptions => {
        DropDownOptions.swipesAndPurchases: 'Swipes & Purchases',
        DropDownOptions.swipes: 'Swipes',
        DropDownOptions.purchases: 'Purchases'
      };
  final DropDownOptions index;

  const ReceiptState(this.index);

  @override
  List<Object> get props => [index];
}

class ReceiptInitial extends ReceiptState {
  const ReceiptInitial(DropDownOptions index) : super(index);
}

class ReceiptLoading extends ReceiptState {
  const ReceiptLoading(DropDownOptions index) : super(index);
}

class ReceiptLoaded extends ReceiptState {
  final List<Receipt> receiptsCached;
  final List<Receipt> receiptsForDisplay;

  const ReceiptLoaded({
    required this.receiptsCached,
    required this.receiptsForDisplay,
    required DropDownOptions index,
  }) : super(index);

  @override
  List<Object> get props => [receiptsCached, receiptsForDisplay, index];
}
