import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:coffeecard/widgets/components/forms/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasscodeRepeatForm extends StatelessWidget {
  const ChangePasscodeRepeatForm({required this.passcode});

  final String passcode;

  static Route routeWith({required String passcode}) {
    return FastSlideTransition(
      child: ChangePasscodeRepeatForm(passcode: passcode),
    );
  }

  void _onSubmit(BuildContext context, String passcode) {
    context.read<UserCubit>().setUserPasscode(passcode);
    // Go to the start of the nested flow and exit it
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context, rootNavigator: true).maybePop(context);
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
        InputValidator.bool(
          forceErrorMessage: true,
          validate: (text) => text == passcode,
          errorMessage: Strings.registerPasscodeDoesNotMatch,
        ),
      ],
      title: Strings.changePasscodeRepeatTitle,
      label: Strings.changePasscodeRepeatLabel,
      type: TextFieldType.passcode,
      autoSubmitValidInput: true,
      onSubmit: (passcode) => _onSubmit(context, passcode),
    );
  }
}
