// ignore_for_file: prefer_const_constructors

import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/rounded_button.dart';
import 'package:flutter/material.dart';

class AppBarWithNotification extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool displayNotification;

  AppBarWithNotification({
    required this.title,
    this.displayNotification = false,
    Key? key,
  })  : preferredSize = Size.fromHeight(
          displayNotification ? 100 : 60,
        ),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyle.pageTitle),
      bottom:
          displayNotification ? ConnectedToTestDatabaseNotification() : null,
    );
  }
}

class ConnectedToTestDatabaseNotification extends StatelessWidget
    implements PreferredSizeWidget {
  ConnectedToTestDatabaseNotification({Key? key})
      : preferredSize = Size.fromHeight(10),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      //FIXME: popup
      text: 'Connected to test environment', onPressed: () {},
      background: AppColor.white, textStyle: TextStyle(color: AppColor.primary),
    );
  }
}
