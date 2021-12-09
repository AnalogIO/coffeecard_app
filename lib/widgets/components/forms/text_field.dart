import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum TextFieldType { text, email, passcode }

/// Should always be contained in an `AppForm`.
class AppTextField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? hint;
  final String? error;
  final TextFieldType type;
  final bool autofocus;
  final bool lastField;
  final TextEditingController? controller;
  final String? Function(String)? validator;

  const AppTextField({
    required this.label,
    this.initialValue,
    this.hint,
    this.error,
    this.type = TextFieldType.text,
    this.autofocus = false,
    this.lastField = false,
    this.validator,
    this.controller,
  });

  // FIXME not true at the moment
  /// Text field that will call `validator` when any of the following are true:
  /// * Text field is submitted (with keyboard action)
  /// * Text field is unfocused
  /// * Text field is updated AND the field has an error.
  // const AppTextField.withValidator({
  //   required this.label,
  //   required this.validator,
  //   this.initialValue,
  //   this.hint,
  //   this.error,
  //   this.type = TextFieldType.text,
  //   this.autofocus = false,
  //   this.lastField = false,
  // });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  double opacityLevel = 0.5;
  late FocusNode _focusNode;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  void _onOnFocusNodeEvent() {
    setState(() {}); // Re-renders
    _changeOpacity(_focusNode.hasFocus ? 1.0 : 0.5);
  }

  void _changeOpacity(double opacity) {
    setState(() => opacityLevel = opacity);
  }

  bool get _isPasscode => widget.type == TextFieldType.passcode;

  TextInputType get _keyboardType {
    if (widget.type == TextFieldType.email) return TextInputType.emailAddress;
    if (widget.type == TextFieldType.passcode) return TextInputType.number;
    return TextInputType.text;
  }

  UnderlineInputBorder get _defaultBorder {
    return const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      borderSide: BorderSide(color: AppColor.gray),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      inputFormatters: _isPasscode
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4)
            ]
          : null,
      keyboardType: _keyboardType,
      obscureText: _isPasscode,
      obscuringCharacter: '⬤',
      textInputAction:
          widget.lastField ? TextInputAction.done : TextInputAction.next,
      validator: (value) => widget.validator?.call(value!),
      // TODO: also call validator on unfocus
      // onFieldSubmitted: (value) => widget.validator?.call(value),
      decoration: InputDecoration(
        border: _defaultBorder,
        enabledBorder: _defaultBorder,
        focusedBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          borderSide: BorderSide(color: AppColor.secondary, width: 2),
        ),
        labelText: widget.label,
        labelStyle:
            const TextStyle(color: AppColor.secondary, letterSpacing: 0),
        filled: true,
        fillColor: AppColor.white.withOpacity(opacityLevel),
        contentPadding:
            const EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
        helperText: widget.hint,
        helperMaxLines: 2,
        helperStyle: const TextStyle(
          color: AppColor.secondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        errorText: widget.error,
        errorMaxLines: 2,
      ),
      cursorWidth: 1,
      style: TextStyle(
        color: AppColor.primary,
        letterSpacing: _isPasscode ? 3 : 0,
      ),
    );
  }
}
