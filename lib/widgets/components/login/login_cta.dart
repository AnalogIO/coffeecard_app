import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
        },
        builder: (context, state) {
        return FlatButton(
          onPressed: () => state.toString(), //TODO Fix this
          child: Text(
            "state.ctaText", //TODO fix this
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
