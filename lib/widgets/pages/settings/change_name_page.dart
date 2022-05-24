import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/forms/settings/change_name_form.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';

class ChangeNamePage extends StatelessWidget {
  const ChangeNamePage({required this.name});
  final String name;

  static Route routeWith({required String name}) =>
      MaterialPageRoute(builder: (_) => ChangeNamePage(name: name));

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeName,
      applyPadding: true,
      body: ChangeNameForm(currentName: name),
    );
  }
}
