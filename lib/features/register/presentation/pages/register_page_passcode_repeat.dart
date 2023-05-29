import 'package:coffeecard/features/register/presentation/pages/register_page_occupation.dart';
import 'package:coffeecard/features/register/presentation/widgets/forms/register_passcode_repeat_form.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RegisterPasscodeRepeatForm(
        passcode: passcode,
        onSubmit: (_) {
          final _ = Navigator.push(
            context,
            RegisterPageOccupation.routeWith(email: email, passcode: passcode),
          );
        },
      ),
    );
  }
}
