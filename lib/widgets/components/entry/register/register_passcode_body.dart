import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/widgets/components/entry/register/register_continue_button.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:coffeecard/widgets/routers/register_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPasscodeBody extends StatefulWidget {
  const RegisterPasscodeBody();
  @override
  State<RegisterPasscodeBody> createState() => _RegisterPasscodeBodyState();
}

class _RegisterPasscodeBodyState extends State<RegisterPasscodeBody> {
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

  bool _buttonEnabled() =>
      firstPasscode.isNotEmpty &&
      secondPasscode.isNotEmpty &&
      !(firstError != null || secondError != null);

  void _focusSecondField() {
    _secondPasscodeFocusNode.requestFocus();
  }

  void _validateFirstPasscode(String passcode) {
    if (passcode.isEmpty) {
      firstError = Strings.registerPasscodeEmpty;
    } else if (passcode.length < 4) {
      firstError = Strings.registerPasscodeTooShort;
    } else {
      firstError = null;
      _focusSecondField();
    }
  }

  void _validateSecondPasscode(String passcode) {
    // Do not show an error if the previous passcode field has an error.
    if (firstError != null) return;
    if (passcode.isEmpty) {
      secondError = Strings.registerPasscodeRepeatEmpty;
    } else if (passcode != firstPasscode) {
      secondError = Strings.registerPasscodeDoesNotMatch;
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
    context.read<RegisterCubit>().setPasscode(firstPasscode);
    RegisterFlow.push(RegisterFlow.nameRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppTextField(
          label: Strings.registerPasscodeLabel,
          autofocus: true,
          error: firstError,
          type: TextFieldType.passcode,
          onChanged: _onFirstChanged,
          onEditingComplete: () => _validateFirstPasscode(firstPasscode),
          controller: _firstPasscodeController,
        ),
        AppTextField(
          label: Strings.registerPasscodeRepeatLabel,
          hint: Strings.registerPasscodeHint,
          error: secondError,
          type: TextFieldType.passcode,
          onChanged: () => _onSecondChanged(context),
          onEditingComplete: () => _submit(context),
          controller: _secondPasscodeController,
          focusNode: _secondPasscodeFocusNode,
        ),
        RegisterContinueButton(
          onPressed: () => _submit(context),
          enabled: _buttonEnabled(),
        )
      ],
    );
  }
}
