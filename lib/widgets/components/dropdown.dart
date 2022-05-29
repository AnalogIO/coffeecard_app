import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';

class Dropdown<FilterCategory> extends StatelessWidget {
  final bool loading;
  final FilterCategory value;
  final List<DropdownMenuItem<FilterCategory>>? items;
  final void Function(FilterCategory?) onChanged;

  const Dropdown({
    required this.loading,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  Container get _underline {
    return Container(
      height: 1.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _color,
            width: 0.0,
          ),
        ),
      ),
    );
  }

  Color get _color => loading ? AppColor.lightGray : AppColor.white;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(disabledColor: AppColor.lightGray),
      child: DropdownButton(
        dropdownColor: AppColor.secondary,
        underline: _underline,
        icon: Icon(Icons.arrow_drop_down, color: _color),
        style: AppTextStyle.buttonText,
        value: value,
        items: items,
        onChanged: loading ? null : onChanged,
      ),
    );
  }
}
