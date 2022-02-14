import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: AppColor.white,
        child: BlocBuilder<ReceiptCubit, ReceiptState>(
          builder: (context, state) {
            if (state.status.isInitial) {
              return _ReceiptsPlaceholder();
            }
            return RefreshIndicator(
              displacement: 24,
              onRefresh: context.read<ReceiptCubit>().fetchReceipts,
              child: state.filteredReceipts.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: AppColor.secondary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Receipts for your purchases and swipes, will show up here',
                                style: AppTextStyle.explainer,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ],
                      ),
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
      ),
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
