import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ReceiptsListView extends StatelessWidget {
  const ReceiptsListView({required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ReceiptCubit, ReceiptState>(
        builder: (context, state) {
          if (state.status.isInitial) {
            return _ReceiptsPlaceholder();
          }
          return RefreshIndicator(
            displacement: 24,
            onRefresh: context.read<ReceiptCubit>().fetchReceipts,
            child: state.filteredReceipts.isEmpty
                ? _ReceiptsEmptyIndicator(
                    hasNoReceipts: state.receipts.isEmpty,
                    filterCategory: state.filterBy,
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: state.filteredReceipts.length,
                    itemBuilder: (_, index) {
                      final r = state.filteredReceipts[index];
                      return ReceiptListEntry(receipt: r);
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _ReceiptsEmptyIndicator extends StatelessWidget {
  const _ReceiptsEmptyIndicator({
    required this.hasNoReceipts,
    required this.filterCategory,
  });

  /// The user has no receipts of any kind.
  final bool hasNoReceipts;

  final ReceiptFilterCategory filterCategory;

  /// If the user has no receipts of any kind, always show a generic message.
  /// Otherwise, show a message based on `filterCategory`.
  String get _title => hasNoReceipts
      ? Strings.noReceiptsOfTypeTitle(Strings.receipts)
      : Strings.noReceiptsOfTypeTitle(filterCategory.name.toLowerCase());

  String get _buyOrSwipe {
    if (hasNoReceipts) return Strings.buyOrSwipe;
    return filterCategory == ReceiptFilterCategory.swipes
        ? Strings.buy
        : Strings.swipe;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Gap(48),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _title,
            textAlign: TextAlign.center,
            style: AppTextStyle.sectionTitle,
            overflow: TextOverflow.visible,
          ),
        ),
        const Gap(8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            Strings.noReceiptsOfTypeMessage(_buyOrSwipe),
            textAlign: TextAlign.center,
            style: AppTextStyle.explainer,
          ),
        ),
      ],
    );
  }
}

class _ReceiptsPlaceholder extends StatelessWidget {
  final placeholderListEntries = List.generate(
    20,
    (_) => ReceiptListEntry(
      receipt: Receipt(
        timeUsed: DateTime.now(),
        productName: Strings.receiptPlaceholderName,
        transactionType: TransactionType.placeholder,
        price: -1,
        amountPurchased: 1,
        id: -1,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: placeholderListEntries,
    );
  }
}
