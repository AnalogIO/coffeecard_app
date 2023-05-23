import 'package:coffeecard/base/strings.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const ErrorDialog({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: Text(title),
      content: child,
      actions: <Widget>[
        TextButton(
          child: const Text(Strings.purchaseErrorOk),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
