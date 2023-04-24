import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/widgets/components/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptCubit, ReceiptState>(
      builder: (context, state) {
        return Dropdown<ReceiptFilterCategory>(
          loading: false,
          value: state.filterBy,
          onChanged: (category) {
            context.read<ReceiptCubit>().filterReceipts(category!);
          },
          items: ReceiptFilterCategory.values
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
