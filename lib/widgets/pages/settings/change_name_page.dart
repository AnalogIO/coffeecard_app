import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/continue_button.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeNamePage extends StatefulWidget {
  final String initialValue;

  const ChangeNamePage({required this.initialValue, Key? key})
      : super(key: key);

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  late TextEditingController _controller;
  String get name => _controller.text;

  final bool _showError = false;
  String? _error;

  bool _buttonEnabled() => name.isNotEmpty && _error == null;

  Future<void> _validateName(String name) async {
    setState(() => _error = name.isEmpty ? Strings.registerNameEmpty : null);
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  void _submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) context.read<UserCubit>().setUserName(text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: 'Edit name',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(
              label: 'Enter your name',
              autofocus: true,
              error: _showError ? _error : null,
              onChanged: () => _validateName(_controller.text),
              onEditingComplete: () => _submit(context),
              controller: _controller,
            ),
            ContinueButton(
              onPressed: () => _submit(context),
              enabled: _buttonEnabled(),
            )
          ],
        ),
      ),
    );
  }
}
