import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class Dropdown<T> extends StatelessWidget {
  final bool loading;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final TextStyle? textStyle;
  final Color? dropdownColor;

  const Dropdown({
    required this.loading,
    required this.value,
    required this.items,
    required this.onChanged,
    this.textStyle,
    this.dropdownColor,
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

  Color get _color =>
      loading ? AppColors.lightGray : (dropdownColor ?? AppColors.white);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(disabledColor: AppColors.lightGray),
      child: DropdownButton(
        dropdownColor: dropdownColor ?? AppColors.secondary,
        underline: _underline,
        icon: Icon(Icons.arrow_drop_down, color: _color),
        style: textStyle ?? AppTextStyle.buttonText,
        value: value,
        items: items,
        onChanged: loading ? null : onChanged,
      ),
    );
  }
}
