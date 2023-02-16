import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/forms/register/register_passcode_repeat_form.dart';
import 'package:coffeecard/widgets/pages/register/register_page_name.dart';
import 'package:flutter/material.dart';

class RegisterPagePasscodeRepeat extends StatelessWidget {
  const RegisterPagePasscodeRepeat({
    required this.email,
    required this.passcode,
  });

  final String email;
  final String passcode;

  static Route routeWith({required String email, required String passcode}) {
    return FastSlideTransition(
      child: RegisterPagePasscodeRepeat(email: email, passcode: passcode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegisterPasscodeRepeatForm(
      passcode: passcode,
      onSubmit: (_) {
        Navigator.push(
          context,
          RegisterPageName.routeWith(email: email, passcode: passcode),
        );
      },
    );
  }
}
