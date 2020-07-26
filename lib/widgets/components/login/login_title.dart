import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    return Consumer<LoginState>(
      builder: (context, state, child) {
        return Padding(
        padding: EdgeInsets.only(top: 32, bottom: 16),
        child: Text(
          "Sign in",
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
