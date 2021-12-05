import 'package:coffeecard/widgets/routers/login_router.dart';
import 'package:flutter/material.dart';

// TODO extend this widget to contain Register flow?
class EntryRouter extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => EntryRouter());

  @override
  Widget build(BuildContext context) {
    return LoginRouter();
  }
}
