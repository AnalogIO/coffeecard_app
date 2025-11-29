import 'package:coffeecard/home_loader.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/theme.dart';
import 'package:coffeecard/core/widgets/pages/home_page.dart';
import 'package:coffeecard/core/widgets/pages/splash/splash_error_page.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_email.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/product/purchasable_products.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
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
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final products = context.read<ProductCubit>().state as ProductsLoaded;
          return HomePage(products: products.products);
        }
      ),
      GoRoute(
        path: '/error',
        builder: (context, state) => SplashErrorPage(errorMessage: state.extra as String? ?? 'Unknown error'),
      ),
      // Add more routes here
    ],
    redirect: (context, state) {
      final authCubit = context.read<AuthenticationCubit>();
      final envCubit = context.read<EnvironmentCubit>();
      final productCubit = context.read<ProductCubit>();

      final authStatus = authCubit.state.status;
      final envState = envCubit.state;

      // Wait for both to load
      final authLoaded = !authStatus.isUnknown;
      final envLoaded = envState is EnvironmentLoaded;

      if (!authLoaded || !envLoaded) {
        return state.uri.path == '/' ? null : '/';
      }

      // If not authenticated, go to login
      if (!authStatus.isAuthenticated) {
        if (state.uri.path.startsWith('/login')) return null;
        return '/login?fromSplash=true';
      }

      // If authenticated but not on home, redirect to home
      // Note: You'll need to handle user/product loading separately
      if (!state.uri.path.startsWith('/home') && productCubit.state is ProductsLoaded) {
        return '/home';
      }

      return null; // No redirect needed
    },
    refreshListenable: RouterRefreshNotifier(
      sl<AuthenticationCubit>(),
      sl<EnvironmentCubit>(),
      sl<ProductCubit>()
    ),
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
  RouterRefreshNotifier(this.authCubit, this.envCubit, this.productCubit) {
    authCubit.stream.listen((_) => notifyListeners());
    envCubit.stream.listen((_) => notifyListeners());
    productCubit.stream.listen((_) => notifyListeners());
  }

  final AuthenticationCubit authCubit;
  final EnvironmentCubit envCubit;
  final ProductCubit productCubit;
}