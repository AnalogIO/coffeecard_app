import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../blocs/login/login_bloc.dart';

import 'login_input_email.dart';
import 'login_input_password.dart';


class LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
        return Visibility(
          visible: state.onPage == OnPage.inputEmail,
          child: LoginInputEmail(),
          replacement: LoginInputPassword()
        );
      }
    );
  }
}
