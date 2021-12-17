import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/entry/register/register_enter_email.dart';
import 'package:coffeecard/widgets/components/entry/register/register_enter_passcode.dart';
// import 'package:coffeecard/widgets/components/entry/register/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => RegisterPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('Register', style: AppTextStyle.pageTitle),
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(
          repository: sl.get<AccountRepository>(),
        ),
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                if (state.email == null) return true;
                if (state.passcode == null) {
                  BlocProvider.of<RegisterBloc>(context).add(RemoveEmail());
                } else {
                  BlocProvider.of<RegisterBloc>(context).add(RemovePasscode());
                }
                return false;
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _getPage(state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getPage(RegisterState state) {
    if (state.email == null) return RegisterEnterEmail();
    if (state.passcode == null) return RegisterEnterPasscode();
    return Container();
  }
}
