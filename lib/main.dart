import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/theme.dart';
import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/routers/auth_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  configureServices();
  runApp(const App());
}

class App extends StatelessWidget {
  // TODO How are app instantiated in newest flutter?
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppView();
  }
}

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(sl.get<SecureStorage>())..add(AppStarted()),
      child: MaterialApp(
        title: Strings.appTitle,
        theme: analogTheme,
        home: AuthRouter(),
      ),
    );
  }
}
