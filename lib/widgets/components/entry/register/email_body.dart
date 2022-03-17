import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/utils/debouncer.dart';
import 'package:coffeecard/utils/email_utils.dart';
import 'package:coffeecard/widgets/components/continue_button.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:flutter/material.dart';

class EmailBody extends StatefulWidget {
  final Function(BuildContext context, String email) onSubmit;
  final String? initialValue;
  final String? hint;

  const EmailBody({
    required this.onSubmit,
    this.initialValue,
    this.hint,
  });
  @override
  State<EmailBody> createState() => _EmailBodyState();
}

class _EmailBodyState extends State<EmailBody> {
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

  Future<void> _validateEmail(String email) async {
    final _email = email.trim();
    if (_email.isEmpty) {
      error = Strings.registerEmailEmpty;
    } else if (!emailIsValid(_email)) {
      error = Strings.registerEmailInvalid;
    } else if (widget.initialValue != null && _email == widget.initialValue) {
      error = Strings.changeEmailCannotBeSame;
    } else {
      final isDuplicate = await emailIsDuplicate(_email);
      if (!mounted) return; // Needs to be checked after an async call.
      if (isDuplicate) {
        _showError = true;
        error = '$_email ${Strings.registerEmailInUseSuffix}';
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
    if (!mounted) return;
    if (_validated) {
      widget.onSubmit(context, _controller.text);
    }
    setState(() {
      _readOnly = false;
      _showError = true;
    });
  }

  @override
  void initState() {
    final initialValue = widget.initialValue;

    if (initialValue != null) {
      _controller.text = initialValue;
      _validateEmail(initialValue);
    }

    super.initState();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AppTextField(
            label: Strings.registerEmailLabel,
            hint: widget.hint,
            autofocus: true,
            error: errorMessage,
            type: TextFieldType.email,
            loading: _loading,
            showCheckMark: _validated,
            readOnly: _readOnly,
            onChanged: _onChanged,
            onEditingComplete: () => _submit(context),
            controller: _controller,
          ),
          ContinueButton(
            onPressed: () => _submit(context),
            enabled: _validated,
          )
        ],
      ),
    );
  }
}
