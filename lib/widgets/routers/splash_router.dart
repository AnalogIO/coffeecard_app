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
  var _authStatus = AuthenticationStatus.unknown;
  bool? _isTestEnvironment;

  void _authListener(BuildContext _, AuthenticationState state) {
    _authStatus = state.status;
    _maybeNavigate();
  }

  void _envListener(BuildContext _, EnvironmentState state) {
    if (state is EnvironmentError) {
      // FIXME: Handle error
    }
    _isTestEnvironment = state is EnvironmentLoaded && state.isTestEnvironment;
    _maybeNavigate();
  }

  /// Navigates to the appropriate flow when both
  /// _authStatus and _environment are loaded.
  void _maybeNavigate() {
    if (_authStatus.isUnknown || _isTestEnvironment == null) return;
    // FIXME: The transition needs animation
    widget.navigatorKey.currentState!.pushAndRemoveUntil(
      _authStatus.isAuthenticated ? HomePage.route : LoginRouter.route,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EnvironmentCubit, EnvironmentState>(
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
