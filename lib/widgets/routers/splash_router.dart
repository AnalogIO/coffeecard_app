import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/routers/entry_router.dart';
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
  var _authStatus = AuthenticationStatus.unknown;
  var _environment = Environment.unknown;

  void _authListener(BuildContext _, AuthenticationState state) {
    _authStatus = state.status;
    _maybeNavigate();
  }

  void _envListener(BuildContext _, Environment env) {
    _environment = env;
    _maybeNavigate();
  }

  /// Navigates out of the splash screen if both
  /// _authStatus and _environment are loaded.
  void _maybeNavigate() {
    if (_authStatus.isUnknown || _environment.isUnknown) return;
    // FIXME: The transition needs animation
    widget.navigatorKey.currentState!.pushAndRemoveUntil(
      _authStatus.isAuthenticated ? HomePage.route : EntryRouter.route,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EnvironmentCubit, Environment>(
          listener: _envListener,
        ),
        BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: _authListener,
        ),
      ],
      child: widget.child,
    );
  }
}
