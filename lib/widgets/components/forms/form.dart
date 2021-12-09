import 'package:flutter/material.dart';

class AppForm extends StatelessWidget {
  final List<Widget> children;
  final GlobalKey<FormState> formKey;
  const AppForm({required this.formKey, required this.children});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: children,
      ),
    );
  }
}
