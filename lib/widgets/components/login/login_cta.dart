import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (context, state, child) {
        return FlatButton(
          onPressed: () => state.ctaChangePageFunction(),
          child: Text(
            state.ctaText,
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
