import 'package:coffeecard/core/ignore_value.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/features/shared/form.dart';
import 'package:coffeecard/service_locator.dart';
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
            final emailExistsResult =
                await sl<AccountRemoteDataSource>().emailExists(text);

            return emailExistsResult.fold(
              (error) => const Left(Strings.emailValidationError),
              (emailExists) => emailExists
                  ? const Right(unit)
                  : const Left(Strings.forgotPasscodeNoAccountExists),
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
    ignoreValue(LoadingOverlay.show(context));

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
              LoadingOverlay.hide(context);
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
