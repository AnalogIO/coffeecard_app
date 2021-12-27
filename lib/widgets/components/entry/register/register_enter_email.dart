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

  bool _loading = false;
  bool _showError = false;
  bool _disabled = false;
  bool _validated = false;

  String? _error;
  String? get error => _error;
  set error(String? error) {
    setState(() => _error = error);
  }

  String? get errorMessage => _showError ? _error : null;

  // FIXME email validation is code duplication
  bool _isValid(String email) {
    return RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+').hasMatch(email);
  }

  // FIXME should check if email is duplicate instead (belongs in another class)
  Future<bool> _isDuplicate(String email) async {
    return Future.delayed(const Duration(milliseconds: 250), () => false);
  }

  Future<void> _validateEmail(String email) async {
    setState(() => _loading = true);
    if (email.isEmpty) {
      error = 'Enter an email';
    } else if (!_isValid(email)) {
      error = 'Enter a valid email';
    } else if (await _isDuplicate(email)) {
      _showError = true;
      error = '$email is already in use';
    } else {
      error = null;
    }
    setState(() {
      _validated = error == null;
      _loading = false;
    });
  }

  void _onChanged() {
    _debounce(() => _validateEmail(_controller.text));
  }

  Future<void> _submit(BuildContext context) async {
    setState(() => _disabled = true);
    _debounce.cancel();
    await _validateEmail(_controller.text);
    setState(() => _showError = true);
    if (_validated && mounted) {
      BlocProvider.of<RegisterBloc>(context).add(AddEmail(_controller.text));
    }
    setState(() => _disabled = false);
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
              error: errorMessage,
              type: TextFieldType.email,
              loading: _loading,
              readOnly: _disabled,
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
