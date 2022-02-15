import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dropdown<Cubit extends StateStreamable<State>, State,
    FilterCategory extends Enum> extends StatelessWidget {
  final void Function(FilterCategory?) onChanged;
  final FilterCategory value;
  final Iterable<Map<String, dynamic>> items;

  Dropdown({
    required this.onChanged,
    required this.items,
    required this.value,
  });

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
    return BlocBuilder<Cubit, State>(
      builder: (context, state) {
        return DropdownButton<FilterCategory>(
          dropdownColor: AppColor.secondary,
          underline: underline,
          icon: const Icon(Icons.arrow_drop_down, color: AppColor.white),
          style: AppTextStyle.buttonText,
          value: value,
          items: items
              .map(
                (c) => DropdownMenuItem<FilterCategory>(
                  value: c['e'] as FilterCategory,
                  child: Text(
                    c['name'] as String,
                    style: AppTextStyle.loginExplainer,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        );
      },
    );
  }
}
