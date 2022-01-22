import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';

Future<void> appDialog({
  required BuildContext context,
  required String title,
  required List<Widget> children,
  required List<Widget> actions,
  required bool dismissible,
  bool transparentBarrier = false,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: transparentBarrier ? Colors.transparent : AppColor.scrim,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => dismissible,
        child: AlertDialog(
          title: Text(title, style: AppTextStyle.ownedTicket),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          elevation: 24,
          content: SingleChildScrollView(child: ListBody(children: children)),
          actions: actions,
        ),
      );
    },
  );
}

void closeAppDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
