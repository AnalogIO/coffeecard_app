import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/widgets/components/dropdowns/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptDropdown extends Dropdown {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptCubit, ReceiptState>(
      builder: (context, state) {
        return DropdownButton<ReceiptFilterCategory>(
          dropdownColor: dropdownColor,
          underline: underline,
          value: state.filterBy,
          icon: icon,
          style: style,
          onChanged: (category) {
            context.read<ReceiptCubit>().filterReceipts(category!);
          },
          items: ReceiptFilterCategory.values
              .map(
                (c) => DropdownMenuItem<ReceiptFilterCategory>(
                  value: c,
                  child: Text(c.name, style: AppTextStyle.loginExplainer),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
