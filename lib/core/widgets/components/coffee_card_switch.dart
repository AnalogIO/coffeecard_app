import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CoffeeCardSwitch extends StatefulWidget {
  final void Function(bool)? onChanged;
  final bool value;

  const CoffeeCardSwitch({this.onChanged, required this.value});

  @override
  State<CoffeeCardSwitch> createState() => _CoffeeCardSwitchState();
}

class _CoffeeCardSwitchState extends State<CoffeeCardSwitch> {
  late bool enabled;

  @override
  void initState() {
    enabled = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      inactiveTrackColor: AppColors.background,
      inactiveThumbColor: AppColors.primary,
      activeTrackColor: AppColors.background,
      activeColor: AppColors.primary,
      value: enabled,
      onChanged: (v) {
        setState(() => enabled = v);
        widget.onChanged?.call(v);
      },
    );
  }
}
