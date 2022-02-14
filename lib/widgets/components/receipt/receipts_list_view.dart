import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ReceiptsListView extends StatelessWidget {
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
                    hasAnyReceipts: state.receipts.isNotEmpty,
                    filterCategory: state.filterBy,
                  )
                : ListView.builder(
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
    required this.hasAnyReceipts,
    required this.filterCategory,
  });

  final bool hasAnyReceipts;
  final FilterCategory filterCategory;

  String get _message => !hasAnyReceipts
      ? Strings.noReceiptsOfType(Strings.receipts)
      : Strings.noReceiptsOfType(filterCategory.name.toLowerCase());

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Gap(48),
        Text(
          _message,
          textAlign: TextAlign.center,
          style: AppTextStyle.explainer,
          overflow: TextOverflow.visible,
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
