import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/theme.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/data/repositories/v1/app_config_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/splash_page.dart';
import 'package:coffeecard/widgets/routers/splash_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  configureServices();
  runApp(App());
}

class App extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  AuthenticationCubit _createAuthenticationCubit(BuildContext _) {
    final storage = sl.get<SecureStorage>();
    return AuthenticationCubit(storage)..appStarted();
  }

  EnvironmentCubit _createEnvironmentCubit(BuildContext _) {
    final repo = sl.get<AppConfigRepository>();
    return EnvironmentCubit(repo)..getConfig();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: _createAuthenticationCubit),
        BlocProvider(create: _createEnvironmentCubit),
      ],
      child: SplashRouter(
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
