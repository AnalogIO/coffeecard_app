import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/widgets/components/entry/register/register_verification_code_text_field.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterVerifyEmail extends RegisterPage {
  RegisterVerifyEmail()
      : super(
          appBarTitle: 'Verify',
          body: _VerifyEmailBody(),
        );
}

class _VerifyEmailBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = BlocProvider.of<RegisterBloc>(context).state.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please enter the six-digit verification code that was sent to $email.',
          style: AppTextStyle.explainer,
        ),
        const SizedBox(height: 16),
        RegisterVerificationCodeTextField(),
      ],
    );
  }
}
