import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class Upgrader extends StatelessWidget {
  final Widget child;
  const Upgrader({required this.child});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(child: child);
  }
}
