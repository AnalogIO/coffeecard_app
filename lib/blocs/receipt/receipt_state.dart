part of 'receipt_cubit.dart';

enum FilterCategory { all, swipes, purchases }
enum ReceiptStatus { initial, loading, success, failure }

extension DropdownName on FilterCategory {
  String get name {
    if (this == FilterCategory.all) return 'Swipes & purchases';
    if (this == FilterCategory.swipes) return 'Swipes';
    if (this == FilterCategory.purchases) return 'Purchases';
    throw Exception('Unknown filter category: $this');
  }
}

extension ReceiptStatusIs on ReceiptStatus {
  bool get isInitial => this == ReceiptStatus.initial;
  bool get isLoading => this == ReceiptStatus.loading;
  bool get isSuccess => this == ReceiptStatus.success;
  bool get isFailure => this == ReceiptStatus.failure;
}

class ReceiptState extends Equatable {
  final ReceiptStatus status;
  final FilterCategory filterBy;
  final List<Receipt> receipts;
  final List<Receipt> filteredReceipts;
  ReceiptState({
    this.status = ReceiptStatus.initial,
    this.filterBy = FilterCategory.all,
    List<Receipt>? receipts,
    List<Receipt>? filteredReceipts,
  })  : receipts = receipts ?? [],
        filteredReceipts = filteredReceipts ?? [];

  @override
  List<Object> get props => [status, filterBy, receipts, filteredReceipts];

  ReceiptState copyWith({
    ReceiptStatus? status,
    FilterCategory? filterBy,
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
