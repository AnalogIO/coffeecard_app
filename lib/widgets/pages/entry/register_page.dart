import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/widgets/components/forms/form.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => RegisterPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('Register', style: AppTextStyle.pageTitle),
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: AppForm(
                children: [
                  AppTextField(
                    label: 'Email',
                    hint: 'You will need to verify your email address later.',
                    error: state.emailError,
                    autofocus: true,
                    type: TextFieldType.email,
                  ),
                  const SizedBox(height: 24),
                  const AppTextField(
                    label: 'Passcode',
                    type: TextFieldType.passcode,
                  ),
                  const SizedBox(height: 12),
                  AppTextField.withValidator(
                    label: 'Repeat passcode',
                    hint: 'Enter a four-digit passcode.',
                    error: state.passcodeError,
                    type: TextFieldType.passcode,
                    validator: (passcode) {
                      BlocProvider.of<RegisterBloc>(context)
                          .add(VerifyForm(repeatPasscodeValue: passcode));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
