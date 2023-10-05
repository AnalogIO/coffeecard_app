/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020-12-26 14:08
library;

import 'package:flutter/material.dart';

typedef LazyWidgetBuilder = Widget Function(BuildContext context);

class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
  });

  final int index;
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;

  @override
  _LazyIndexedStackState createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late final Map<int?, bool> _innerWidgetMap = Map<int?, bool>.fromEntries(
    List<MapEntry<int, bool>>.generate(
      widget.children.length,
      (int i) => MapEntry<int, bool>(i, i == index),
    ),
  );

  late int index = widget.index;

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      index = widget.index;
    }
  }

  void _activeCurrentIndex(int? index) {
    if (_innerWidgetMap[index] != true) {
      _innerWidgetMap[index] = true;
    }
  }

  bool _hasInit(int index) {
    final bool? result = _innerWidgetMap[index];
    if (result == null) {
      return false;
    }
    return result;
  }

  List<Widget> _buildChildren() {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < widget.children.length; i++) {
      if (_hasInit(i)) {
        list.add(widget.children[i]);
      } else {
        list.add(const SizedBox.shrink());
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _activeCurrentIndex(index);
    return IndexedStack(
      index: index,
      alignment: widget.alignment,
      sizing: widget.sizing,
      textDirection: widget.textDirection,
      children: _buildChildren(),
    );
  }
}
