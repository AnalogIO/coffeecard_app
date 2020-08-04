import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
        return Padding(
        padding: EdgeInsets.only(top: 32, bottom: 16),
        child: Text(
          "state.username", //TODO Fix this
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
