import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final childWidget = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.white,
        border: const Border(bottom: BorderSide(color: AppColor.lightGray)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leftWidget,
            rightWidget,
          ],
        ),
      ),
    );

    if (onTap == null) {
      return childWidget;
    } else {
      return Tappable(
        onTap: onTap!,
        child: childWidget,
      );
    }
  }
}
