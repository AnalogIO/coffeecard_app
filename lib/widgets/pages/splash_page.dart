import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  final Widget? child;

  const SplashPage({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primary,
      child: child,
    );
  }
}
