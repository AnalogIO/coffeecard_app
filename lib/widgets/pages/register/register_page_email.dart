import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/forms/register/register_email_form.dart';
import 'package:coffeecard/widgets/pages/register/register_page_passcode.dart';
import 'package:flutter/material.dart';

class RegisterPageEmail extends StatelessWidget {
  const RegisterPageEmail();

  static Route get route =>
      FastSlideTransition(child: const RegisterPageEmail());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RegisterEmailForm(
        onSubmit: (email) {
          final _ = Navigator.push(
              context, RegisterPagePasscode.routeWith(email: email));
        },
      ),
    );
  }
}
