import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dropdown<T extends StateStreamable<K>, K, C> extends StatelessWidget {
  final void Function(C?) onChanged;
  final C value;
  final List<DropdownMenuItem<C>> items;

  Dropdown({required this.onChanged, required this.items, required this.value});

  final underline = Container(
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, K>(
      builder: (context, state) {
        return DropdownButton<C>(
          dropdownColor: AppColor.secondary,
          underline: underline,
          icon: const Icon(Icons.arrow_drop_down, color: AppColor.white),
          style: AppTextStyle.buttonText,
          value: value,
          items: items,
          onChanged: onChanged,
        );
      },
    );
  }
}
