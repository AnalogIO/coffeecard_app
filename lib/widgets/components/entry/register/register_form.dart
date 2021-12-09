import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/widgets/components/forms/form.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passcodeController = TextEditingController();
  final _repeatPasscodeController = TextEditingController();

  String? _emailValidator(String email) {
    if (email.isEmpty) {
      return 'Enter an email';
    }
    // FIXME email validation is code duplication
    if (!RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+').hasMatch(email)) {
      return 'Enter a valid email';
    }
  }

  String? _passcodeValidator(String passcode) {
    if (passcode.isEmpty) {
      return 'Enter a passcode';
    }
    if (passcode.length < 4) {
      return 'Enter a four-digit passcode';
    }
  }

  String? _repeatPasscodeValidator(String passcode) {
    // Do not show an error the the previous passcode field has an error.
    if (_passcodeValidator(_passcodeController.text) != null) {
      return null;
    }
    if (passcode.length < 4) {
      return 'Repeat the passcode';
    }
    if (passcode != _passcodeController.text) {
      return 'Passcodes do not match';
    }
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<RegisterBloc>(context).add(
        AttemptRegister(
          email: _emailController.text,
          passcode: _passcodeController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, String?>(
      builder: (context, emailError) {
        return AppForm(
          formKey: _formKey,
          children: [
            AppTextField(
              label: 'Email',
              hint: 'You will need to verify your email address later.',
              autofocus: true,
              error: emailError,
              type: TextFieldType.email,
              controller: _emailController,
              validator: _emailValidator,
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Passcode',
              type: TextFieldType.passcode,
              controller: _passcodeController,
              validator: _passcodeValidator,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Repeat passcode',
              hint: 'Enter a four-digit passcode.',
              type: TextFieldType.passcode,
              controller: _repeatPasscodeController,
              validator: _repeatPasscodeValidator,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _submit(context),
              child: const Text('Validate'),
            ),
          ],
        );
      },
    );
  }
}
