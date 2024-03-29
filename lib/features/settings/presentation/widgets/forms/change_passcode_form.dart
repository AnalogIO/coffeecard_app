import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/validator/input_validator.dart';
import 'package:coffeecard/core/widgets/fast_slide_transition.dart';
import 'package:coffeecard/features/form/presentation/widgets/form.dart';
import 'package:coffeecard/features/settings/presentation/widgets/forms/change_passcode_repeat_form.dart';
import 'package:flutter/material.dart';

class ChangePasscodeForm extends StatelessWidget {
  const ChangePasscodeForm();

  static Route get route =>
      FastSlideTransition(child: const ChangePasscodeForm());

  void _onSubmit(BuildContext context, String passcode) {
    final _ = Navigator.push(
      context,
      ChangePasscodeRepeatForm.routeWith(passcode: passcode),
    );
  }

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
      title: Strings.changePasscodeTitle,
      label: Strings.changePasscodeLabel,
      hint: Strings.changePasscodeHint,
      type: TextFieldType.passcode,
      autoSubmitValidInput: true,
      onSubmit: (passcode) => _onSubmit(context, passcode),
    );
  }
}
