import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginInputEmail extends StatelessWidget {
  const LoginInputEmail();

  get _inputField =>  BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
      final errorBorder = OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.highlight, width: 4),
        borderRadius: BorderRadius.all(Radius.circular(32)),
      );
      return TextField(
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
        
        onChanged: (email) {context.bloc<LoginBloc>().add(LoginEmailChanged(email) ); }

      );
    }
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return SizedBox(height: 50,
          child: Form(
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
                        onPressed: () {context.bloc<LoginBloc>().add(LoginEmailSubmitted()); },
                        tooltip: "Submit",
                      )
                  )
                ],
              )
          ),
        );
      },
    );
  }
}


