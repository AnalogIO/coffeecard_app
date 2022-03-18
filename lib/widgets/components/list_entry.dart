import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ListEntry extends StatelessWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final void Function()? onTap;
  final Color? backgroundColor;

  const ListEntry({
    required this.leftWidget,
    required this.rightWidget,
    this.onTap,
    this.backgroundColor,
  });

  Widget get _leftWidget =>
      Row(children: [Flexible(child: leftWidget), const Gap(24)]);
  Widget get _rightWidget => rightWidget;

  @override
  Widget build(BuildContext context) {
    final childWidget = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.white,
        border: const Border(bottom: BorderSide(color: AppColor.lightGray)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Flexible(child: _leftWidget), _rightWidget],
        ),
      ),
    );
    return Tappable(
      onTap: onTap,
      child: childWidget,
    );
  }
}
