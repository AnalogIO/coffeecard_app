import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/utils/debouncer.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterEmailTextField extends StatefulWidget {
  @override
  State<RegisterEmailTextField> createState() => _RegisterEmailTextFieldState();
}

class _RegisterEmailTextFieldState extends State<RegisterEmailTextField> {
  final _controller = TextEditingController();
  final _debounce = Debouncer(delay: const Duration(milliseconds: 250));

  bool _loading = false;
  bool _showError = false;
  bool _readOnly = false;
  String? _validatedEmail;
  bool get _validated => _validatedEmail == _controller.text;

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
    if (email.isEmpty) {
      error = 'Enter an email';
    } else if (!_isValid(email)) {
      error = 'Enter a valid email';
    } else {
      final isDuplicate = await _isDuplicate(email);
      if (!mounted) return; // Needs to be checked after an async call.
      if (isDuplicate) {
        _showError = true;
        error = '$email is already in use';
      } else {
        error = null;
      }
    }
    setState(() {
      _validatedEmail = (error == null) ? email : null;
      _loading = false;
    });
  }

  void _onChanged() {
    setState(() => _loading = true);
    _debounce(() => _validateEmail(_controller.text));
  }

  Future<void> _submit(BuildContext context) async {
    if (_loading) {
      _debounce.dispose();
      setState(() => _readOnly = true);
      await _validateEmail(_controller.text);
    }
    if (_validated && mounted) {
      BlocProvider.of<RegisterBloc>(context).add(AddEmail(_controller.text));
    }
    setState(() {
      _readOnly = false;
      _showError = true;
    });
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
        return AppTextField(
          label: 'Email',
          hint: 'You will need to verify your email address later.',
          autofocus: true,
          error: errorMessage,
          type: TextFieldType.email,
          loading: _loading,
          showCheckMark: _validated,
          readOnly: _readOnly,
          onChanged: _onChanged,
          onEditingComplete: () => _submit(context),
          controller: _controller,
        );
      },
    );
  }
}
