import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/blocs/receipt/receipt_cubit.dart';
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
              child: ListView.builder(
                itemCount: state.filteredReceipts.length,
                itemBuilder: (_, index) {
                  final r = state.filteredReceipts[index];
                  if (r.transactionType == TransactionType.purchase) {
                    return ReceiptListEntry.purchase(
                      productName: r.productName,
                      time: r.timeUsed,
                      quantity: r.amountPurchased,
                      price: r.price,
                    );
                  } else {
                    return ReceiptListEntry.swipe(
                      productName: r.productName,
                      time: r.timeUsed,
                    );
                  }
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
  final placeholderListEntries =
      List.generate(20, (_) => ReceiptListEntry.placeholder());
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: placeholderListEntries,
    );
  }
}
