import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/login.dart';
import 'package:flutter/material.dart';

class ForgotPasscodePage extends StatefulWidget {
  const ForgotPasscodePage({required this.initialValue});

  final String initialValue;

  static Route routeWith({required String initialValue}) {
    return MaterialPageRoute(
      builder: (_) => ForgotPasscodePage(initialValue: initialValue),
    );
  }

  @override
  State<ForgotPasscodePage> createState() => _ForgotPasscodePageState();
}

class _ForgotPasscodePageState extends State<ForgotPasscodePage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.forgotPasscode,
      applyPadding: true,
      body: ForgotPasscodeForm(initialValue: widget.initialValue),
    );
  }
}
