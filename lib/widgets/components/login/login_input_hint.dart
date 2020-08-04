import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginInputHint extends StatefulWidget {
  @override
  _LoginInputHintState createState() => _LoginInputHintState();
}

class _LoginInputHintState extends State<LoginInputHint> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            (true) //TODO fix this
              ? "state.hintText"
              : "state.errorText",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: (true) //TODO fix this
                ? AppColor.white
                : AppColor.highlight,
              fontSize: 14
            ),
          ),
        );
      }
    );
  }
}
