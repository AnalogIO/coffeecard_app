import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class LoginEmailTextField extends StatefulWidget {
  const LoginEmailTextField({
    required this.hasError,
    required this.autoFocusDelay,
    required this.onSubmit,
    required this.onChange,
  });

  final bool hasError;
  final Duration autoFocusDelay;
  final void Function(BuildContext, String) onSubmit;
  final void Function() onChange;

  @override
  State<LoginEmailTextField> createState() => _LoginEmailTextFieldState();
}

class _LoginEmailTextFieldState extends State<LoginEmailTextField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    // Focus the text field after animations have completed
    () async {
      await Future.delayed(widget.autoFocusDelay);
      if (mounted) _focusNode.requestFocus();
    }();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() {
      widget.onSubmit(context, _controller.text.trim());
    }

    InputDecoration getInputDecoration() {
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: widget.hasError
            ? const BorderSide(color: AppColor.errorOnDark, width: 2)
            : const BorderSide(color: Colors.transparent, width: 0),
      );

      return InputDecoration(
        constraints: const BoxConstraints(maxWidth: 260),
        hintStyle: const TextStyle(color: AppColor.gray),
        hintText: Strings.loginHintEmail,
        border: const OutlineInputBorder(),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: AppColor.white,
        suffixIcon: IconButton(
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_forward, size: 20),
          onPressed: onSubmit,
          tooltip: Strings.loginTooltipContinue,
        ),
        contentPadding: const EdgeInsets.only(top: 12, bottom: 12, left: 24),
      );
    }

    return TextField(
      controller: _controller,
      autocorrect: false,
      focusNode: _focusNode,
      keyboardType: TextInputType.emailAddress,
      decoration: getInputDecoration(),
      style: const TextStyle(color: AppColor.primary),
      cursorWidth: 1,
      onEditingComplete: onSubmit,
      onChanged: (_) => widget.onChange(),
    );
  }
}
