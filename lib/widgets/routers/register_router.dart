import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_email_page.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_name_page.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_passcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterRouter extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => RegisterRouter());

  Widget _currentPage(RegisterState state) {
    if (state.email == null) return RegisterEmailPage();
    if (state.passcode == null) return RegisterPasscodePage();
    if (state.name == null) return RegisterNamePage();
    // return RegisterTermsPage();
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return RegisterBloc(repository: sl.get<AccountRepository>());
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          bool _add(RegisterEvent event) {
            BlocProvider.of<RegisterBloc>(context).add(event);
            return false;
          }

          return WillPopScope(
            onWillPop: () async {
              if (state.email == null) return true;
              if (state.passcode == null) return _add(RemoveEmail());
              if (state.name == null) return _add(RemovePasscode());
              return false; // TODO: figure out what to do from here
            },
            child: _currentPage(state),
          );
        },
      ),
    );
  }
}
