import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/widgets/components/forms/form.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterEnterName extends StatefulWidget {
  @override
  State<RegisterEnterName> createState() => _RegisterEnterNameState();
}

class _RegisterEnterNameState extends State<RegisterEnterName> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  bool _showError = false;
  String? _error;

  Future<void> _validateName(String name) async {
    setState(() => _error = name.trim().isEmpty ? 'Enter a name' : null);
  }

  Future<void> _submit(BuildContext context) async {
    _showError = true;
    await _validateName(_controller.text);
    if (_error != null || !mounted) return;
    BlocProvider.of<RegisterBloc>(context).add(AddName(_controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return AppForm(
          formKey: _formKey,
          children: [
            const SectionTitle.register('Enter your name'),
            AppTextField(
              label: 'Name',
              hint:
                  'Your name may appear on the leaderboards. You can choose to appear anonymous at any time.',
              autofocus: true,
              error: _showError ? _error : null,
              onChanged: () => _validateName(_controller.text),
              onEditingComplete: () => _submit(context),
              controller: _controller,
            ),
          ],
        );
      },
    );
  }
}
