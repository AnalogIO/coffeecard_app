import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/features/shared/form.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

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
            final either =
                await sl<AccountRemoteDataSource>().emailExists(text);

            return either.fold(
              (l) => const Left(Strings.emailValidationError),
              (r) => r
                  ? Left(Strings.registerEmailInUse(text))
                  : const Right(unit),
            );
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
