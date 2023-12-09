import 'package:coffeecard/core/widgets/components/helpers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

enum GridGap { normal, tightVertical, tight }

extension _GridGapSizes on GridGap {
  double get horizontal => this == GridGap.tight ? 8 : 12;
  double get vertical => this == GridGap.normal ? 12 : 8;
}

class Grid extends StatelessWidget {
  const Grid({
    required this.singleColumnOnSmallDevice,
    required this.gap,
    required this.gapSmall,
    required this.children,
  });

  /// Whether to show a single column when the display is small.
  final bool singleColumnOnSmallDevice;

  /// Determines the spacing between grid items.
  final GridGap gap;

  /// Determines the spacing between grid items when the display is small.
  final GridGap gapSmall;

  /// The grid items.
  final List<Widget> children;

  double _horizontalGap(bool isSmall) =>
      isSmall ? gapSmall.horizontal : gap.horizontal;

  double _verticalGap(bool isSmall) =>
      isSmall ? gapSmall.vertical : gap.vertical;

  int _columns(bool isSmall) => isSmall && singleColumnOnSmallDevice ? 1 : 2;

  int _rows(bool isSmall) => (children.length / _columns(isSmall)).ceil();

  @override
  Widget build(BuildContext context) {
    final isSmall = deviceIsSmall(context);
    final horizontalGap = _horizontalGap(isSmall);
    final verticalGap = _verticalGap(isSmall);
    final columns = _columns(isSmall);
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutGrid(
      columnSizes: List.filled(columns, 1.fr),
      rowSizes: List.filled(_rows(isSmall), auto),
      columnGap: horizontalGap,
      rowGap: verticalGap,
      children: children,
    );
  }
}
