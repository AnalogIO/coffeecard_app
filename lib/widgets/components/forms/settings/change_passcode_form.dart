import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:coffeecard/widgets/components/forms/form.dart';
import 'package:coffeecard/widgets/components/forms/settings/change_passcode_repeat_form.dart';
import 'package:flutter/material.dart';

class ChangePasscodeForm extends StatelessWidget {
  const ChangePasscodeForm();

  static Route get route =>
      FastSlideTransition(child: const ChangePasscodeForm());

  void _onSubmit(BuildContext context, String passcode) {
    Navigator.push(
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
