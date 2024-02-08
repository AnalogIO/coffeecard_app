import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CoffeeCardSwitch extends StatefulWidget {
  final void Function(bool)? onChanged;
  final bool value;
  final bool? loading;

  const CoffeeCardSwitch({this.onChanged, required this.value, this.loading});

  @override
  State<CoffeeCardSwitch> createState() => _CoffeeCardSwitchState();
}

class _CoffeeCardSwitchState extends State<CoffeeCardSwitch> {
  @override
  Widget build(BuildContext context) {
    if (widget.loading != null && widget.loading!) {
      return const CircularProgressIndicator();
    }

    return Switch(
      inactiveTrackColor: AppColors.background,
      inactiveThumbColor: AppColors.primary,
      activeTrackColor: AppColors.background,
      activeColor: AppColors.primary,
      value: widget.value,
      onChanged: (v) => setState(() => widget.onChanged?.call(v)),
    );
  }
}
