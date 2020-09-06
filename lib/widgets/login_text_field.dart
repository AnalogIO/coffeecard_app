import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginTextField extends StatefulWidget {
  final String value;
  final String placeholder;
  final bool error;

  const LoginTextField({
    Key key,
    this.value = '',
    this.placeholder = 'Placeholder...',
    this.error = false
  }) : super(key: key);

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    final _border = OutlineInputBorder(
      borderSide: widget.error
        ? BorderSide(color: AppColor.error, width: 2)
        : BorderSide.none,
      borderRadius: BorderRadius.circular(32)
    );

    void submit() {
      throw UnimplementedError();
    }

    final inputDecoration = InputDecoration(
      hintText: widget.placeholder,
      hintStyle: TextStyle(color: AppColor.gray),

      border: OutlineInputBorder(),
      enabledBorder: _border,
      focusedBorder: _border,

      filled: true,
      fillColor: AppColor.white,

      suffixIcon: IconButton(
        enableFeedback: true,
        splashColor: Colors.transparent,
        icon: Icon(Icons.arrow_forward),
        onPressed: () => submit(),
        tooltip: 'Go',
      ),

      contentPadding: EdgeInsets.only(
        top: 13,
        bottom: 13,
        left: 24,
        right: 64
      ),
    );

    return TextField(
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecoration,
      style: TextStyle(color: AppColor.primary),
      cursorWidth: 1,
      onSubmitted: (_) => submit(),
    );
  }
}
