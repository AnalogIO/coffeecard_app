import 'package:coffeecard/core/input_validator.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/form/presentation/widgets/form.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/service_locator.dart';
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
            final either =
                await sl<AccountRemoteDataSource>().emailExists(text);

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
