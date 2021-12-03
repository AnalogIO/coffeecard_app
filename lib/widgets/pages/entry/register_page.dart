import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => RegisterPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('Register', style: AppTextStyle.pageTitle),
      ),
      body: const Text('bitchass'),
    );
  }
}
