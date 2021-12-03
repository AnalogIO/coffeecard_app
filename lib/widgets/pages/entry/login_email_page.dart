import 'package:coffeecard/blocs/entry/entry_router_cubit.dart';
import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_email_text_field.dart';
import 'package:coffeecard/widgets/pages/entry/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void _changeRoute(BuildContext context) {
  BlocProvider.of<EntryRouterCubit>(context).changeRoute(EntryRoute.register);
}

class LoginEmailPage extends LoginPage {
  LoginEmailPage()
      : super(
          inputWidget: const LoginEmailTextField(),
          resizeOnKeyboard: true,
          ctaChildren: [
            const LoginCTA(
              text: "Don't have an account? Make one",
              onPressed: _changeRoute,
            ),
          ],
        );
}
