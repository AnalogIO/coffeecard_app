import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginInputEmail extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const LoginInputEmail(this.formKey);

  get _inputField => Consumer<LoginState>(
    builder: (context, state, child) {
      final RegExp regExEmail = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      final errorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.highlight, width: 4),
        borderRadius: BorderRadius.all(Radius.circular(32)),
      );

      return TextFormField(
        textInputAction: TextInputAction.next,
        
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "Email...",
          contentPadding: EdgeInsets.fromLTRB(24, 16, 64, 16),
          errorStyle: TextStyle(color: AppColor.highlight, height: 0, fontSize: 0),
          fillColor: AppColor.white,
          filled: true,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            borderSide: BorderSide.none
          )
        ),
        autofocus: true,
        
        onFieldSubmitted: (value) {context.bloc<LoginBloc>},
        onSaved: (value) {
          // Handle email input
          if (formKey.currentState.validate()) {
            FocusScope.of(context).unfocus();
            state.username = value;
            state.page = (state.page == LoginPages.email)
              ? LoginPages.password
              : LoginPages.registerPassword;
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            state.errorText = "Enter an email\n";
            return '';
          }
          if (!regExEmail.hasMatch(value)) {
            state.errorText = "Enter a valid email\n";
            return '';
          }
          return null;
        }
      );
    }
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Form(
        key: formKey,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: _inputField
            ),
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                splashColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                icon: Icon(Icons.arrow_forward),
                onPressed: () {formKey.currentState.save();},
                tooltip: "Submit",
              )
            )
          ],
        )
      ),
    );
  }
}
