import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptCubit, ReceiptState>(
      builder: (context, state) {
        return DropdownButton<FilterCategory>(
          dropdownColor: AppColor.secondary,
          underline: _underline,
          value: state.filterBy,
          icon: const Icon(Icons.arrow_drop_down, color: AppColor.white),
          style: AppTextStyle.buttonText,
          onChanged: (category) {
            context.read<ReceiptCubit>().filterReceipts(category!);
          },
          items: FilterCategory.values
              .map(
                (c) => DropdownMenuItem<FilterCategory>(
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

final _underline = Container(
  height: 1.0,
  decoration: const BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: AppColor.slightlyHighlighted,
        width: 0.0,
      ),
    ),
  ),
);
