import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.onPage != current.onPage,
        builder: (context, state) {
        return Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 16),
        child: Text(
          (state.onPage == OnPage.inputEmail) ? "Sign in" : state.email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.white,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      );
      }
    );
  }
}
