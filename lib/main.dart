import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/theme.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/persistence/repositories/authentication_repository.dart';
import 'package:coffeecard/service_locator.dart';
// import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'widgets/pages/splash.dart';

void main() {
  configureServices();
  runApp(App());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      theme: analogTheme,
      home: LoginPage(),
    );
  }
}

class App extends StatelessWidget {
  const App({
    Key key,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
     return BlocProvider(
        create: (_) => AuthenticationBloc(
          accountRepository: sl.get<AccountRepository>(),
          authenticationRepository: sl.get<AuthenticationRepository>()),
             child: AppView());
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: Strings.appTitle,
      theme: analogTheme,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                      (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                      (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}