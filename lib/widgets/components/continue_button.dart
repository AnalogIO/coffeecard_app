import 'package:coffeecard/widgets/components/rounded_button.dart';
import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final Function() onPressed;
  final bool enabled;

  const ContinueButton({
    required this.onPressed,
    required this.enabled,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: 'Continue',
      onPressed: onPressed,
      disabled: !enabled,
    );
  }
}
