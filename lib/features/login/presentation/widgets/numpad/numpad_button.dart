import 'package:coffeecard/core/widgets/components/helpers/responsive.dart';
import 'package:coffeecard/core/widgets/design/glass_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A round passcode key. Digit keys are [filled] with a dark glass
/// surface; secondary keys ("Forgot?", delete) are plain.
class NumpadButton extends StatelessWidget {
  final void Function(BuildContext) onPressed;
  final Widget child;
  final bool filled;
  final String? semanticLabel;

  const NumpadButton({
    required this.child,
    required this.onPressed,
    this.filled = true,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final size = deviceIsSmall(context) ? 64.0 : 76.0;

    final key = Material(
      type: MaterialType.transparency,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed(context);
        },
        child: SizedBox.square(dimension: size, child: Center(child: child)),
      ),
    );

    return Center(
      child: Semantics(
        button: true,
        label: semanticLabel,
        child: filled
            ? GlassSurface(
                dark: true,
                radius: size / 2,
                elevated: false,
                child: key,
              )
            : key,
      ),
    );
  }
}
