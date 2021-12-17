import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/utils/debouncer.dart';
import 'package:coffeecard/widgets/components/forms/form.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterEnterEmail extends StatefulWidget {
  @override
  State<RegisterEnterEmail> createState() => _RegisterEnterEmailState();
}

class _RegisterEnterEmailState extends State<RegisterEnterEmail> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _debounce = Debouncer(delay: const Duration(milliseconds: 250));

  bool _showError = false;
  bool _loading = false;

  String? _error;
  String? get error => _error;
  set error(String? error) {
    if (!_showError) return;
    setState(() => _error = error);
  }

  // FIXME email validation is code duplication
  bool _isValid(String email) {
    return !RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+').hasMatch(email);
  }

  // FIXME should check if email is duplicate instead (belongs in another class)
  Future<bool> _isDuplicate(String email) async {
    return Future.delayed(const Duration(milliseconds: 250), () => true);
  }

  Future<void> _validateEmail(String email) async {
    setState(() => _loading = true);
    if (email.isEmpty) {
      error = 'Enter an email';
    } else if (_isValid(email)) {
      error = 'Enter a valid email';
    } else if (await _isDuplicate(email)) {
      _showError = true;
      error = '$email is already in use';
    } else {
      error = null;
    }
    setState(() => _loading = false);
  }

  void _onChanged() {
    _debounce(() => _validateEmail(_controller.text));
  }

  Future<void> _submit(BuildContext context) async {
    _showError = true;
    await _validateEmail(_controller.text);
    if (error != null) return;
    if (!mounted) return; // Two if statements used to satisfy the code checker.
    BlocProvider.of<RegisterBloc>(context).add(AddEmail(_controller.text));
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return AppForm(
          formKey: _formKey,
          children: [
            const SectionTitle.register('Enter your email'),
            AppTextField(
              label: 'Email',
              hint: 'You will need to verify your email address later.',
              autofocus: true,
              error: error,
              type: TextFieldType.email,
              loading: _loading,
              onChanged: _onChanged,
              onEditingComplete: () => _submit(context),
              controller: _controller,
            ),
          ],
        );
      },
    );
  }
}
