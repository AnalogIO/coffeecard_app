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
    final border = OutlineInputBorder(
      borderSide: widget.error
        ? BorderSide(color: AppColor.error, width: 2)
        : BorderSide.none,
      borderRadius: BorderRadius.circular(32)
    );

    final inputDecoration = InputDecoration(
      hintText: widget.placeholder,
      hintStyle: TextStyle(color: AppColor.gray),

      border: OutlineInputBorder(),
      enabledBorder: border,
      focusedBorder: border,

      filled: true,
      fillColor: AppColor.white,

      contentPadding: EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 24,
        right: 64
      ),
    );

    void submit({bool tappedArrow = false}) {
      if (tappedArrow) HapticFeedback.vibrate();

      Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Enter your passcode')
      ));
    }

    return SizedBox(
      height: 45,
      child: Stack(
        children: <Widget>[
          TextField(
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration,
            style: TextStyle(color: AppColor.primary),
            cursorWidth: 1,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              enableFeedback: true,
              splashColor: Colors.transparent,
              icon: Icon(Icons.arrow_forward),
              onPressed: () => submit(tappedArrow: true),
              tooltip: 'Submit',
            ),
          ),
        ],
      ),
    );
  }
}
