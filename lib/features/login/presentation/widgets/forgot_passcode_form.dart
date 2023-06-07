import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/core/widgets/form/form.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class ForgotPasscodeForm extends StatelessWidget {
  const ForgotPasscodeForm({required this.initialValue});

  /// The email the user tried logging in to before entering this flow.
  final String initialValue;

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
                  ? const Left(Strings.forgotPasscodeNoAccountExists)
                  : const Right(null),
            );
          },
        ),
      ],
      label: Strings.registerEmailLabel,
      hint: Strings.forgotPasscodeHint,
      initialValue: initialValue,
      type: TextFieldType.email,
      debounce: true,
      showCheckMark: true,
      onSubmit: (name) => _onSubmit(context, name),
    );
  }

  Future<void> _onSubmit(BuildContext context, String email) async {
    showLoadingOverlay(context);

    final either =
        await sl<AccountRemoteDataSource>().requestPasscodeReset(email);

    final title = either.fold(
      (_) => Strings.forgotPasscodeError,
      (_) => Strings.forgotPasscodeLinkSent,
    );
    final body = either.fold(
      (error) => error.reason,
      (_) => Strings.forgotPasscodeSentRequestTo(email),
    );

    if (context.mounted) {
      appDialog(
        context: context,
        title: title,
        dismissible: false,
        children: [Text(body)],
        actions: [
          TextButton(
            onPressed: () {
              closeAppDialog(context);
              hideLoadingOverlay(context);
              // Exits the forgot passcode flow
              Navigator.pop(context);
            },
            child: const Text(Strings.buttonOK),
          ),
        ],
      );
    }
  }
}