import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
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
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() {
      widget.onSubmit(context, _controller.text.trim());
    }

    InputDecoration getInputDecoration() {
      final border = OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: widget.hasError
            ? const BorderSide(color: AppColors.errorOnDark, width: 2)
            : const BorderSide(color: Color(0xffD4CDC3)),
      );

      return InputDecoration(
        constraints: const BoxConstraints(maxWidth: 480),
        hintStyle: const TextStyle(color: AppColors.gray),
        hintText: Strings.loginHintEmail,
        prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
        border: const OutlineInputBorder(),
        enabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: AppColors.secondary, width: 2)),
        filled: true,
        fillColor: AppColors.white,
        suffixIcon: IconButton(
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_forward, size: 20),
          onPressed: onSubmit,
          tooltip: Strings.loginTooltipContinue,
        ),
        contentPadding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
      );
    }

    return TextField(
      controller: _controller,
      autocorrect: false,
      focusNode: _focusNode,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.next,
      decoration: getInputDecoration(),
      style: const TextStyle(color: AppColors.primary),
      cursorWidth: 1,
      onEditingComplete: onSubmit,
      onChanged: (_) => widget.onChange(),
    );
  }
}
