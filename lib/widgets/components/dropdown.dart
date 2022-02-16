import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dropdown<Cubit extends StateStreamable<State>, State, FilterCategory>
    extends StatelessWidget {
  final FilterCategory value;
  final List<DropdownMenuItem<FilterCategory>>? items;
  final void Function(FilterCategory?) onChanged;

  Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
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
        return DropdownButton(
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
