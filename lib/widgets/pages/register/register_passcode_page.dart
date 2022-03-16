import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/widgets/components/entry/register/passcode_body.dart';
import 'package:coffeecard/widgets/pages/register/register_page.dart';
import 'package:coffeecard/widgets/routers/register_flow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPasscodePage extends RegisterPage {
  RegisterPasscodePage()
      : super(
          sectionTitle: Strings.registerPasscodeTitle,
          body: PasscodeBody(
            onSubmit: (context, passcode) {
              context.read<RegisterCubit>().setPasscode(passcode);
              RegisterFlow.push(RegisterFlow.nameRoute);
            },
          ),
        );
}
