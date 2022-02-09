part of 'receipt_cubit.dart';

enum ReceiptFilterCategory { all, swipes, purchases }
enum ReceiptStatus { initial, success, failure }

extension DropdownName on ReceiptFilterCategory {
  String get name {
    if (this == ReceiptFilterCategory.all) return Strings.receiptFilterAll;
    if (this == ReceiptFilterCategory.swipes) return Strings.receiptFilterSwipes;
    if (this == ReceiptFilterCategory.purchases) return Strings.receiptFilterPurchases;
    throw Exception('Unknown filter category: $this');
  }
}

extension ReceiptStatusIs on ReceiptStatus {
  bool get isInitial => this == ReceiptStatus.initial;
  bool get isSuccess => this == ReceiptStatus.success;
  bool get isFailure => this == ReceiptStatus.failure;
}

class ReceiptState extends Equatable {
  final ReceiptStatus status;
  final ReceiptFilterCategory filterBy;
  final List<Receipt> receipts;
  final List<Receipt> filteredReceipts;
  ReceiptState({
    this.status = ReceiptStatus.initial,
    this.filterBy = ReceiptFilterCategory.all,
    List<Receipt>? receipts,
    List<Receipt>? filteredReceipts,
  })  : receipts = receipts ?? [],
        filteredReceipts = filteredReceipts ?? [];

  @override
  List<Object> get props => [status, filterBy, receipts, filteredReceipts];

  ReceiptState copyWith({
    ReceiptStatus? status,
    ReceiptFilterCategory? filterBy,
    List<Receipt>? receipts,
    List<Receipt>? filteredReceipts,
  }) {
    return ReceiptState(
      status: status ?? this.status,
      filterBy: filterBy ?? this.filterBy,
      receipts: receipts ?? this.receipts,
      filteredReceipts: filteredReceipts ?? this.filteredReceipts,
    );
  }
}
