import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/login/login_bloc.dart';
import 'login_input_password.dart';
import 'login_text_field.dart';


class LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.onPage != current.onPage,
      builder: (context, state) {
      return Visibility(
        // TODO Consider if this is best practice. Consideration: Shall it be the responsibility of LoginState to know which page the UI is on?
            visible: state.onPage == OnPage.inputEmail,
          replacement: LoginInputPassword(),
          child: const LoginTextField(),
        );
      }
    );
  }
}
