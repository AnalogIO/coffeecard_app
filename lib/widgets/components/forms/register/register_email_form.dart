import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/widgets/form/form.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class RegisterEmailForm extends StatelessWidget {
  const RegisterEmailForm({required this.onSubmit});
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
        InputValidator(
          forceErrorMessage: true,
          validate: (text) async {
            final either = await sl<AccountRepository>().emailExists(text);

            return either.fold(
              (l) => const Left(Strings.emailValidationError),
              (r) => r
                  ? Left(Strings.registerEmailInUse(text))
                  : const Right(null),
            );
          },
        ),
      ],
      title: Strings.registerEmailTitle,
      label: Strings.registerEmailLabel,
      hint: Strings.registerEmailHint,
      type: TextFieldType.email,
      debounce: true,
      showCheckMark: true,
      onSubmit: onSubmit,
    );
  }
}
