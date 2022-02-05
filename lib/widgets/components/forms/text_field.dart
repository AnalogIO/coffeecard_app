import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldType { text, email, passcode, verificationCode }

class AppTextField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? hint;
  final String? error;
  final TextFieldType type;
  final bool autofocus;
  final bool lastField;
  final bool loading;
  final bool showCheckMark;
  final bool readOnly;
  final void Function()? onChanged;
  final TextEditingController? controller;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;

  const AppTextField({
    required this.label,
    this.initialValue,
    this.hint,
    this.error,
    this.type = TextFieldType.text,
    this.autofocus = false,
    this.lastField = false,
    this.loading = false,
    this.showCheckMark = false,
    this.readOnly = false,
    this.onChanged,
    this.onEditingComplete,
    this.controller,
    this.focusNode,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  double opacityLevel = 0.5;
  late FocusNode _focusNode;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  void _onOnFocusNodeEvent() {
    _changeOpacity(_focusNode.hasFocus ? 1.0 : 0.5);
  }

  void _changeOpacity(double opacity) {
    setState(() => opacityLevel = opacity);
  }

  bool get _isPasscode => widget.type == TextFieldType.passcode;

  TextInputType get _keyboardType {
    if (widget.type == TextFieldType.email) return TextInputType.emailAddress;
    if (widget.type == TextFieldType.passcode ||
        widget.type == TextFieldType.verificationCode) {
      return TextInputType.number;
    }
    return TextInputType.text;
  }

  UnderlineInputBorder get _defaultBorder {
    return const UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      borderSide: BorderSide(color: AppColor.gray),
    );
  }

  Widget? get _suffixIcon {
    if (widget.loading) {
      return _TextFieldSpinner();
    }
    if (widget.showCheckMark) {
      return const Icon(
        Icons.check_circle_outline,
        color: AppColor.secondary,
      );
    }
    return null;
  }

  List<TextInputFormatter>? get _inputFormatters {
    if (_isPasscode || widget.type == TextFieldType.verificationCode) {
      final maxDigits = _isPasscode ? 4 : 6;
      return <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxDigits)
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: widget.controller,
        initialValue: widget.initialValue,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        inputFormatters: _inputFormatters,
        keyboardType: _keyboardType,
        obscureText: _isPasscode,
        obscuringCharacter: '⬤',
        textInputAction:
            widget.lastField ? TextInputAction.done : TextInputAction.next,
        onChanged: (_) => widget.onChanged?.call(),
        onEditingComplete: widget.onEditingComplete,
        readOnly: widget.readOnly,
        // TODO: also call validator on unfocus?
        cursorWidth: 1,
        style: TextStyle(
          color: AppColor.primary,
          letterSpacing: _isPasscode ? 3 : 0,
        ),
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
          suffixIcon: _suffixIcon,
        ),
      ),
    );
  }
}

class _TextFieldSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: 12,
        height: 12,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColor.secondary,
            strokeWidth: 2.2,
          ),
        ),
      ),
    );
  }
}
