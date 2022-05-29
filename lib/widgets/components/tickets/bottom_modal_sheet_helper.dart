import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// The helper text that appears above the modal sheet.
class BottomModalSheetHelper extends StatefulWidget {
  const BottomModalSheetHelper({required this.children});
  final List<Widget> children;

  @override
  State<StatefulWidget> createState() => _BottomModalSheetHelperState();
}

class _BottomModalSheetHelperState extends State<BottomModalSheetHelper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            ...widget.children,
            const Gap(12),
          ],
        ),
      ),
    );
  }
}
