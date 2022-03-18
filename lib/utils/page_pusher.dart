import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';

Future<void> pushPageScaffold({
  required BuildContext context,
  required String title,
  required Widget body,
}) {
  return Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => AppScaffold.withTitle(
        title: title,
        body: body,
      ),
    ),
  );
}
