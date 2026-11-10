import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/design/analog_segmented_control.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Switches the receipts list between all, swipes and purchases.
class ReceiptFilter extends StatelessWidget {
  const ReceiptFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptCubit, ReceiptState>(
      buildWhen: (previous, current) => previous.filterBy != current.filterBy,
      builder: (context, state) {
        return AnalogSegmentedControl<ReceiptFilterCategory>(
          selected: state.filterBy,
          onChanged: context.read<ReceiptCubit>().filterReceipts,
          segments: const [
            AnalogSegment(
                ReceiptFilterCategory.all, Strings.receiptFilterAllShort),
            AnalogSegment(
              ReceiptFilterCategory.swipes,
              Strings.receiptFilterSwipes,
            ),
            AnalogSegment(
              ReceiptFilterCategory.purchases,
              Strings.receiptFilterPurchases,
            ),
          ],
        );
      },
    );
  }
}
