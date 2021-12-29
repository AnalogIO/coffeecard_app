import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPasscodeTextFields extends StatefulWidget {
  @override
  State<RegisterPasscodeTextFields> createState() =>
      _RegisterPasscodeTextFieldsState();
}

class _RegisterPasscodeTextFieldsState
    extends State<RegisterPasscodeTextFields> {
  final _firstPasscodeController = TextEditingController();
  final _secondPasscodeController = TextEditingController();
  final _secondPasscodeFocusNode = FocusNode();

  String get firstPasscode => _firstPasscodeController.text;
  String get secondPasscode => _secondPasscodeController.text;

  String? _firstError;
  String? get firstError => _firstError;
  set firstError(String? error) {
    secondError = null;
    setState(() => _firstError = error);
  }

  String? _secondError;
  String? get secondError => _secondError;
  set secondError(String? error) => setState(() => _secondError = error);

  void _focusSecondField() {
    _secondPasscodeFocusNode.requestFocus();
  }

  void _validateFirstPasscode(String passcode) {
    if (passcode.isEmpty) {
      firstError = 'Enter a passcode';
    } else if (passcode.length < 4) {
      firstError = 'Enter a four-digit passcode';
    } else {
      firstError = null;
      _focusSecondField();
    }
  }

  void _validateSecondPasscode(String passcode) {
    // Do not show an error if the previous passcode field has an error.
    if (firstError != null) return;
    if (passcode.isEmpty) {
      secondError = 'Repeat the passcode';
    } else if (passcode != firstPasscode) {
      secondError = 'Passcodes do not match';
    } else {
      secondError = null;
    }
  }

  void _onFirstChanged() {
    if (firstPasscode.length == 4) {
      firstError = null;
      _focusSecondField();
    }
  }

  void _onSecondChanged(BuildContext context) {
    if (secondPasscode.length == 4) {
      secondError = null;
      _submit(context);
    }
  }

  void _submit(BuildContext context) {
    _validateFirstPasscode(firstPasscode);
    _validateSecondPasscode(secondPasscode);

    if (firstError != null || secondError != null) return;
    BlocProvider.of<RegisterBloc>(context).add(AddPasscode(firstPasscode));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
              label: 'Passcode',
              autofocus: true,
              error: firstError,
              type: TextFieldType.passcode,
              onChanged: _onFirstChanged,
              onEditingComplete: () => _validateFirstPasscode(firstPasscode),
              controller: _firstPasscodeController,
            ),
            AppTextField(
              label: 'Repeat passcode',
              hint: 'Enter a four-digit passcode for your account.',
              error: secondError,
              type: TextFieldType.passcode,
              onChanged: () => _onSecondChanged(context),
              onEditingComplete: () => _submit(context),
              controller: _secondPasscodeController,
              focusNode: _secondPasscodeFocusNode,
            ),
          ],
        );
      },
    );
  }
}
