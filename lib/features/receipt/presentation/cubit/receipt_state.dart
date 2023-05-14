part of 'receipt_cubit.dart';

enum ReceiptFilterCategory { all, swipes, purchases }

enum ReceiptStatus { initial, success, failure }

extension DropdownName on ReceiptFilterCategory {
  String get name {
    switch (this) {
      case ReceiptFilterCategory.all:
        return Strings.receiptFilterAll;
      case ReceiptFilterCategory.swipes:
        return Strings.receiptFilterSwipes;
      case ReceiptFilterCategory.purchases:
        return Strings.receiptFilterPurchases;
    }
  }
}

class ReceiptState extends Equatable {
  final ReceiptStatus status;
  final ReceiptFilterCategory filterBy;
  final List<Receipt> receipts;
  final List<Receipt> filteredReceipts;
  final String? error;
  ReceiptState({
    this.status = ReceiptStatus.initial,
    this.filterBy = ReceiptFilterCategory.all,
    List<Receipt>? receipts,
    List<Receipt>? filteredReceipts,
    this.error,
  })  : receipts = receipts ?? [],
        filteredReceipts = filteredReceipts ?? [];

  @override
  List<Object?> get props =>
      [status, filterBy, receipts, filteredReceipts, error];

  ReceiptState copyWith({
    ReceiptStatus? status,
    ReceiptFilterCategory? filterBy,
    List<Receipt>? receipts,
    List<Receipt>? filteredReceipts,
    String? error,
  }) {
    return ReceiptState(
      status: status ?? this.status,
      filterBy: filterBy ?? this.filterBy,
      receipts: receipts ?? this.receipts,
      filteredReceipts: filteredReceipts ?? this.filteredReceipts,
      error: error ?? this.error,
    );
  }
}
