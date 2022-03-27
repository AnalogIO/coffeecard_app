import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/entry/register/name_body.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeNamePage extends StatelessWidget {
  const ChangeNamePage({required this.name});
  final String name;

  static Route routeWith({required String name}) =>
      MaterialPageRoute(builder: (_) => ChangeNamePage(name: name));

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeName,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: NameBody(
          initialValue: name,
          onSubmit: (context, name) async {
            context.read<UserCubit>().setUserName(name);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
