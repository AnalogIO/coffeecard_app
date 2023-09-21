import 'package:coffeecard/core/widgets/fast_slide_transition.dart';
import 'package:coffeecard/features/register/presentation/pages/register_page_passcode_repeat.dart';
import 'package:coffeecard/features/register/presentation/widgets/forms/register_passcode_form.dart';
import 'package:flutter/material.dart';

class RegisterPagePasscode extends StatelessWidget {
  const RegisterPagePasscode({required this.email});

  final String email;

  static Route routeWith({required String email}) {
    return FastSlideTransition(child: RegisterPagePasscode(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RegisterPasscodeForm(
        onSubmit: (passcode) {
          final _ = Navigator.push(
            context,
            RegisterPagePasscodeRepeat.routeWith(
              email: email,
              passcode: passcode,
            ),
          );
        },
      ),
    );
  }
}
