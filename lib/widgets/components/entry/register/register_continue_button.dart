import 'package:coffeecard/widgets/components/rounded_button.dart';
import 'package:flutter/material.dart';

class RegisterContinueButton extends StatefulWidget {
  final Function() onPressed;
  final bool enabled;

  const RegisterContinueButton({
    required this.onPressed,
    required this.enabled,
    Key? key,
  }) : super(key: key);

  @override
  _RegisterContinueButtonState createState() => _RegisterContinueButtonState();
}

class _RegisterContinueButtonState extends State<RegisterContinueButton> {
  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: 'Continue',
      onPressed: widget.onPressed,
      disabled: !widget.enabled,
    );
  }
}
