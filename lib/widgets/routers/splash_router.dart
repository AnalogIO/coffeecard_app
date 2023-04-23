import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/pages/login/login_page_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashRouter extends StatefulWidget {
  const SplashRouter({required this.navigatorKey, required this.child});

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  _SplashRouterState createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  bool firstNavigation = true;

  /// Navigates out of the splash screen if both
  /// authentication status and environment status are loaded.
  void _maybeNavigate(BuildContext context) {
    final envState = context.read<EnvironmentCubit>().state;
    final authStatus = context.read<AuthenticationCubit>().state.status;

    if (authStatus.isUnknown || envState is! EnvironmentLoaded) return;

    // Where to go if the user is not authenticated.
    final firstNavigationRoute = firstNavigation
        ? LoginPageEmail.routeFromSplash
        : LoginPageEmail.routeFromLogout;

    // If the user is authenticated, go to the home page.
    final Route route =
        authStatus.isAuthenticated ? HomePage.route : firstNavigationRoute;
    firstNavigation = false;

    // Replaces the whole navigation stack with the approriate route.
    final _ = widget.navigatorKey.currentState!
        .pushAndRemoveUntil(route, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EnvironmentCubit, EnvironmentState>(
          listener: (context, _) => _maybeNavigate(context),
        ),
        BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, _) => _maybeNavigate(context),
        ),
      ],
      // The colored container prevents brief black flashes
      // during page transitions
      child: ColoredBox(color: AppColor.primary, child: widget.child),
    );
  }
}
