import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.onPage != current.onPage,
        builder: (context, state) {
        return FlatButton(
          onPressed: () => (state.onPage == OnPage.inputEmail) ? Navigator.push(context, HomePage.route()) : {context.bloc<LoginBloc>().add(const LoginGoBack()) }, //TODO Replace homepage with a register page
          child: Text(
            state.onPage == OnPage.inputEmail ? "Don't have an account? Make one >>" : "Sign in using another account >>",
            style: TextStyle(
              color: AppColor.white,
              fontSize: 12,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline
            ),
          ),
        );
      }
    );
  }
}
