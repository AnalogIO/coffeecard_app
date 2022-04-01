import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/routers/login_router.dart';
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
  /// Navigates out of the splash screen if both
  /// authentication status and enviornment status are loaded.
  void _maybeNavigate(BuildContext context) {
    final envState = context.read<EnvironmentCubit>().state;
    final authStatus = context.read<AuthenticationCubit>().state.status;

    if (authStatus.isUnknown || envState is! EnvironmentLoaded) return;

    // FIXME: The transition needs animation
    widget.navigatorKey.currentState!.pushAndRemoveUntil(
      authStatus.isAuthenticated ? HomePage.route : LoginRouter.route,
      (route) => false,
    );
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
      child: widget.child,
    );
  }
}
