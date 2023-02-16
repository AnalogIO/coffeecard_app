import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:coffeecard/widgets/components/forms/form.dart';
import 'package:flutter/material.dart';

class ChangeEmailForm extends StatelessWidget {
  const ChangeEmailForm({required this.currentEmail, required this.onSubmit});

  final String currentEmail;
  final void Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return FormBase(
      inputValidators: [
        InputValidators.nonEmptyString(
          errorMessage: Strings.registerEmailEmpty,
        ),
        InputValidators.validEmail(
          errorMessage: Strings.registerEmailInvalid,
        ),
        InputValidator.bool(
          forceErrorMessage: true,
          validate: (email) => email != currentEmail,
          errorMessage: Strings.changeEmailCannotBeSame,
        ),
        InputValidator(
          forceErrorMessage: true,
          validate: (text) async {
            final either = await sl<AccountRepository>().emailExists(text);
            if (either.isRight) {
              return (either.right == true)
                  ? Left(Strings.registerEmailInUse(text))
                  : const Right(null);
            } else {
              return const Left(Strings.emailValidationError);
            }
          },
        ),
      ],
      type: TextFieldType.email,
      label: Strings.email,
      hint: Strings.changeEmailLogInAgain,
      debounce: true,
      showCheckMark: true,
      onSubmit: onSubmit,
    );
  }
}
