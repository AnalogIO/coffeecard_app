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

  Widget get _leftWidget => Row(children: [leftWidget, const Gap(48)]);
  Widget get _rightWidget => Flexible(child: rightWidget);

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
          children: [_leftWidget, _rightWidget],
        ),
      ),
    );
    return Tappable(
      onTap: onTap,
      child: childWidget,
    );
  }
}
