import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';

abstract class Dropdown extends StatelessWidget {
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

  final dropdownColor = AppColor.secondary;
  final icon = const Icon(Icons.arrow_drop_down, color: AppColor.white);
  final style = AppTextStyle.buttonText;
}
