import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../blocs/login/login_bloc.dart';

import 'login_input_email.dart';
import 'login_input_password.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (context, state, child) {
        return Visibility(
          visible: state.onPage == OnPage.inputEmail,
          child: BlockProvider(child: LoginInputEmail(_formKey)),
          replacement: LoginInputPassword()
        );
      }
    );
  }
}
