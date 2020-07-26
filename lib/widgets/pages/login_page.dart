import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/login_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnalogLogo(),
              Container(height: 16),
              Text('Sign in', style: AppTextStyle.pageTitle),
              Container(height: 16),
              LoginTextField(error: false, placeholder: "Email..."),
            ],
          ),
        ),
      )
    );
  }
}
