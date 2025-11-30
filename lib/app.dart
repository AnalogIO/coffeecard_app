import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/theme.dart';
import 'package:coffeecard/core/widgets/pages/home_page.dart';
import 'package:coffeecard/core/widgets/pages/splash/splash_error_page.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_email.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/home_loader.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeLoader(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPageEmail(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/error',
        builder: (context, state) => SplashErrorPage(
            errorMessage: state.extra as String? ?? 'Unknown error'),
      ),
      GoRoute(
        path: '/verify',
        pageBuilder: (_, state) {
          print("did it");
          print(
              'Deep link triggered with ID: ${state.uri.queryParameters['status']}');
          return MaterialPage(
            child: SecretScreen(
                id: state.uri.queryParameters['status'] ?? 'testy testy'),
          );
        },
      )
      // Add more routes here
    ],
    redirect: (context, state) {
      print(
          'Redirecting to ${state.uri.queryParameters} loc: ${state.uri.scheme} uri: ${state.uri.path} error ${state.error}');

      final authCubit = context.read<AuthenticationCubit>();
      final envCubit = context.read<EnvironmentCubit>();
      final userCubit = context.read<UserCubit>();

      final authStatus = authCubit.state.status;
      final envState = envCubit.state;

      // Wait for both to load
      final authLoaded = !authStatus.isUnknown;
      final envLoaded = envState is EnvironmentLoaded;

      if (!authLoaded || !envLoaded) {
        return state.uri.path == '/' ? null : '/';
      }

      print('$state');
      // If not authenticated, go to login
      if (!authStatus.isAuthenticated) {
        if (state.uri.path.startsWith('/login')) return null;
        return '/login?fromSplash=true';
      } else if (state.uri.path == '/login') {
        return '/home';
      }

      // If authenticated and the user has been loaded, but not on home, redirect to home
      //if (!state.uri.path.startsWith('/home') &&
      //   userCubit.state is UserLoaded) {
      //  return '/home';
      //}

      return null; // No redirect needed
    },
    refreshListenable: RouterRefreshNotifier(
        sl<AuthenticationCubit>(), sl<EnvironmentCubit>(), sl<UserCubit>()),
  );

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
      child: MaterialApp.router(
        title: Strings.appTitle,
        theme: analogTheme,
        routerConfig: _router,
      ),
    );
  }
}

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this.authCubit, this.envCubit, this.userCubit) {
    authCubit.stream.listen((_) => notifyListeners());
    envCubit.stream.listen((_) => notifyListeners());
    userCubit.stream.listen((_) => notifyListeners());
  }

  final AuthenticationCubit authCubit;
  final EnvironmentCubit envCubit;
  final UserCubit userCubit;
}

class SecretScreen extends StatelessWidget {
  const SecretScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('SECRET PAGE!!! $id')),
    );
  }
}
