import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/tickets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ErrorSection extends StatelessWidget {
  final String error;
  final void Function() retry;
  final bool center;

  const ErrorSection({
    required this.error,
    required this.retry,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Text('${Strings.error}: $error'),
        const Gap(8),
        RoundedButton(text: Strings.buttonTryAgain, onTap: retry),
      ],
    );
  }
}
