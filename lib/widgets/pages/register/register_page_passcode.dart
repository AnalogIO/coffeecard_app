import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/entry/register/passcode_body.dart';
import 'package:coffeecard/widgets/pages/register/register_page_base.dart';
import 'package:coffeecard/widgets/pages/register/register_page_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPagePasscode extends StatelessWidget {
  const RegisterPagePasscode();

  static Route get route =>
      FastSlideTransition(child: const RegisterPagePasscode());

  @override
  Widget build(BuildContext context) {
    return RegisterPageBase(
      sectionTitle: Strings.registerPasscodeTitle,
      body: PasscodeBody(
        onSubmit: (context, passcode) {
          context.read<RegisterCubit>().setPasscode(passcode);
          Navigator.push(context, RegisterPageName.route);
        },
      ),
    );
  }
}
