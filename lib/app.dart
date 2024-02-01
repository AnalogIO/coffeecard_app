import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/theme.dart';
import 'package:coffeecard/core/widgets/pages/splash/splash_error_page.dart';
import 'package:coffeecard/core/widgets/pages/splash/splash_loading_page.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/product.dart';
import 'package:coffeecard/features/redirection/redirection_router.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Force screen orientation to portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<AuthenticationCubit>()..appStarted()),
        BlocProvider.value(value: sl<EnvironmentCubit>()..getConfig()),
        BlocProvider(create: (_) => sl<UserCubit>()),
        BlocProvider.value(value: sl<ProductCubit>()),
      ],
      child: MainRedirectionRouter(
        navigatorKey: _navigatorKey,
        child: MaterialApp(
          title: Strings.appTitle,
          theme: analogTheme,
          navigatorKey: _navigatorKey,
          home: BlocBuilder<EnvironmentCubit, EnvironmentState>(
            builder: (_, state) {
              return (state is EnvironmentError)
                  ? SplashErrorPage(errorMessage: state.message)
                  : const SplashLoadingPage();
            },
          ),
        ),
      ),
    );
  }
}
