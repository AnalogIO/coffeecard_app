import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Represents the left or right side of a [ListEntry] widget
enum ListEntrySide { left, right }

class ListEntry extends StatelessWidget {
  /// The (left or right) side of the widget that should be displayed in full.
  /// The other part will resize based on remaining space.
  final ListEntrySide sideToExpand;

  final Widget leftWidget;
  final Widget rightWidget;
  final void Function()? onTap;
  final Color? backgroundColor;

  const ListEntry({
    required this.leftWidget,
    required this.rightWidget,
    required this.sideToExpand,
    this.onTap,
    this.backgroundColor,
  });

  /// Wraps a left or right widget in a [Flexible]
  /// widget if it's not the [sideToExpand].
  Widget wrapSideInFlex({required ListEntrySide side, required Widget child}) {
    if (side == sideToExpand) return child;
    return Flexible(child: child);
  }

  Widget get _leftWidget {
    return wrapSideInFlex(
      side: ListEntrySide.left,
      child: leftWidget,
    );
  }

  Widget get _rightWidget {
    return wrapSideInFlex(
      side: ListEntrySide.right,
      child: rightWidget,
    );
  }

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
          children: [_leftWidget, const Gap(24), _rightWidget],
        ),
      ),
    );
    return Tappable(
      onTap: onTap,
      child: childWidget,
    );
  }
}
