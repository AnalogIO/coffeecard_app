import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/widgets/pages/home_page.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_email.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
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

  /// Ensures that the environment and authentication states are loaded.
  /// If so, runs [redirect].
  void ensureLoaded(BuildContext context) {
    final envState = context.read<EnvironmentCubit>().state;
    final authStatus = context.read<AuthenticationCubit>().state.status;

    if (!authStatus.isUnknown && envState is EnvironmentLoaded) {
      redirect(context);
    }
  }

  /// Either redirects to the login page or load the user based on
  /// authentication status.
  void redirect(BuildContext context) {
    final authStatus = context.read<AuthenticationCubit>().state.status;

    if (authStatus.isAuthenticated) {
      // User is authenticated; load user details
      // (will redirect to home page as a side effect)
      context.read<UserCubit>().initialize();
      return;
    }

    // User is not authenticated; redirect to login page

    // Different routes are because of animations between pages
    final route = firstNavigation
        ? LoginPageEmail.routeFromSplash
        : LoginPageEmail.routeFromLogout;

    firstNavigation = false;

    // Replaces the whole navigation stack with the approriate route.
    final _ = widget.navigatorKey.currentState!
        .pushAndRemoveUntil(route, (_) => false);
  }

  void navigateToHome() {
    final _ = widget.navigatorKey.currentState!
        .pushAndRemoveUntil(HomePage.route, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EnvironmentCubit, EnvironmentState>(
          listener: (context, _) => ensureLoaded(context),
        ),
        BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, _) => ensureLoaded(context),
        ),
        BlocListener<UserCubit, UserState>(
          listenWhen: (_, current) => current is UserInitiallyLoaded,
          listener: (_, __) => navigateToHome(),
        ),
      ],
      // The colored container prevents brief black flashes
      // during page transitions
      child: ColoredBox(color: AppColors.primary, child: widget.child),
    );
  }
}
