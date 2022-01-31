import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/theme.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/splash_page.dart';
import 'package:coffeecard/widgets/routers/auth_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  configureServices();
  runApp(App());
}

class App extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationCubit(sl.get<SecureStorage>()),
      child: AuthRouter(
        navigatorKey: _navigatorKey,
        child: MaterialApp(
          title: Strings.appTitle,
          theme: analogTheme,
          home: SplashPage(),
          navigatorKey: _navigatorKey,
        ),
      ),
    );
  }
}
