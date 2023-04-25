import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/service_locator.dart';
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

  /// Ensures that the environment and authentication states are loaded.
  /// If so, runs [checkAuthentication]
  void ensureLoaded(BuildContext context) {
    final envState = context.read<EnvironmentCubit>().state;
    final authStatus = context.read<AuthenticationCubit>().state.status;

    if (authStatus.isUnknown || envState is! EnvironmentLoaded) return;
    checkAuthentication(context);
  }

  /// Either redirects to the login page or load the user based on
  /// authentication status
  void checkAuthentication(BuildContext context) {
    final Route route;
    final authStatus = context.read<AuthenticationCubit>().state.status;

    if (authStatus.isAuthenticated) {
      sl<UserCubit>().fetchUserDetails();
      return;
    }

    // Different routes are because of animations between pages
    route = firstNavigation
        ? LoginPageEmail.routeFromSplash
        : LoginPageEmail.routeFromLogout;

    firstNavigation = false;

    // Replaces the whole navigation stack with the approriate route.
    final _ = widget.navigatorKey.currentState!
        .pushAndRemoveUntil(route, (_) => false);
  }

  void navigateToHome(UserWithData userState) {
    final Route route = HomePage.routeWith(user: userState.user);

    final _ = widget.navigatorKey.currentState!
        .pushAndRemoveUntil(route, (_) => false);
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
          listener: (_, state) => navigateToHome(state as UserInitiallyLoaded),
          listenWhen: (_, current) => current is UserInitiallyLoaded,
        ),
      ],
      // The colored container prevents brief black flashes
      // during page transitions
      child: ColoredBox(color: AppColor.primary, child: widget.child),
    );
  }
}
