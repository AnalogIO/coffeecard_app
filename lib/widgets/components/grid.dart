import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class FourGrid extends StatelessWidget {
  // ignore: avoid_multiple_declarations_per_line
  final Widget tl, tr, bl, br;
  final double? spacing;

  const FourGrid({
    Key? key,
    required this.tl,
    required this.tr,
    required this.bl,
    required this.br,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      areas: '''
          tl tr
          bl br
        ''',
      columnSizes: const [auto, auto],
      rowSizes: const [auto, auto],
      columnGap: spacing,
      rowGap: spacing,
      children: [
        tl.inGridArea('tl'),
        tr.inGridArea('tr'),
        bl.inGridArea('bl'),
        br.inGridArea('br'),
      ],
    );
  }
}
