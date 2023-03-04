import 'dart:io';

import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart' as upgrade;

class UpgradeAlert extends StatelessWidget {
  final Widget child;
  const UpgradeAlert({required this.child});

  @override
  Widget build(BuildContext context) {
    return upgrade.UpgradeAlert(
      upgrader: upgrade.Upgrader(
        showReleaseNotes: false,
        dialogStyle: Platform.isIOS
            ? upgrade.UpgradeDialogStyle.cupertino
            : upgrade.UpgradeDialogStyle.material,
      ),
      child: child,
    );
  }
}
