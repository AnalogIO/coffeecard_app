import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumpadButton extends StatelessWidget {
  final void Function(BuildContext) onPressed;
  final Widget child;

  const NumpadButton({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed(context);
      },
      child: child,
    );
  }
}
