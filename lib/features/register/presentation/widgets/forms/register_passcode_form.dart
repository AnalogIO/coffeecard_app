import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/widgets/form/form.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:flutter/material.dart';

class RegisterPasscodeForm extends StatelessWidget {
  const RegisterPasscodeForm({required this.onSubmit});
  final void Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return FormBase(
      inputValidators: [
        InputValidators.nonEmptyString(
          errorMessage: Strings.registerPasscodeEmpty,
        ),
        InputValidator.bool(
          validate: (text) => text.length == 4,
          errorMessage: Strings.registerPasscodeTooShort,
        ),
      ],
      title: Strings.registerPasscodeTitle,
      label: Strings.registerPasscodeLabel,
      hint: Strings.registerPasscodeHint,
      type: TextFieldType.passcode,
      autoSubmitValidInput: true,
      onSubmit: onSubmit,
    );
  }
}