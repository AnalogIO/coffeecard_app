import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/widgets/components/entry/register/email_body.dart';
import 'package:coffeecard/widgets/pages/register/register_page.dart';
import 'package:coffeecard/widgets/routers/register_flow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterEmailPage extends RegisterPage {
  RegisterEmailPage()
      : super(
          sectionTitle: Strings.registerEmailTitle,
          body: EmailBody(
            displayHint: true,
            onSubmit: (context, email) {
              context.read<RegisterCubit>().setEmail(email);
              RegisterFlow.push(RegisterFlow.passcodeRoute);
            },
          ),
        );
}
