import 'package:flutter/material.dart';

class AppForm extends StatelessWidget {
  final List<Widget> children;
  AppForm({required this.children});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: children,
      ),
    );
  }
}
