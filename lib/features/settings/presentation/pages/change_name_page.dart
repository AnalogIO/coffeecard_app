import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/settings/presentation/widgets/forms/change_name_form.dart';
import 'package:flutter/material.dart';

class ChangeNamePage extends StatelessWidget {
  const ChangeNamePage({required this.name});
  final String name;

  static Route routeWith({required String name}) {
    return MaterialPageRoute(builder: (_) => ChangeNamePage(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeName,
      applyPadding: true,
      body: ChangeNameForm(currentName: name),
    );
  }
}
