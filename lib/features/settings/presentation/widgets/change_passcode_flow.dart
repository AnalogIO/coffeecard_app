import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/forms/settings/change_passcode_form.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/routers/app_flow.dart';
import 'package:flutter/material.dart';

class ChangePasscodeFlow extends StatelessWidget {
  const ChangePasscodeFlow();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const ChangePasscodeFlow());

  @override
  Widget build(BuildContext _) {
    return AppScaffold.withTitle(
      title: Strings.changePasscode,
      applyPadding: true,
      body: AppFlow(initialRoute: ChangePasscodeForm.route),
    );
  }
}
