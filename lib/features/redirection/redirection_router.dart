import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/widgets/pages/home_page.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_email.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/product/purchasable_products.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;

/// A router widget that handles the top-level redirection logic for the app
/// (i.e. switching between the login flow and the home flow).
///
/// This widget listens to changes in the authentication and environment state.
/// Once both are loaded, it redirects the user to either the login flow or the
/// home flow depending on whether the user is authenticated or not.
class MainRedirectionRouter extends StatefulWidget {
  const MainRedirectionRouter({
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  _MainRedirectionRouterState createState() => _MainRedirectionRouterState();
}

class _MainRedirectionRouterState extends State<MainRedirectionRouter> {
  /// Used to determine which animation to use when going to the login page.
  bool firstNavigation = true;

  /// This method is called when either the authentication or environment state
  /// changes.
  ///
  /// If both are loaded, the user is redirected to either the login flow or
  /// the home flow depending on whether the user is authenticated or not.
  void onAuthenticationOrEnvironmentChange() {
    final authenticationCubit = context.read<AuthenticationCubit>();
    final environmentState = context.read<EnvironmentCubit>().state;
    final authenticationStatus = authenticationCubit.state.status;

    // Ensure both environment and authentication state are
    // loaded before proceeding.
    final authenticationLoaded = !authenticationStatus.isUnknown;
    final environmentLoaded = environmentState is EnvironmentLoaded;
    if (authenticationLoaded && environmentLoaded) {
      handleAuthentication(authenticationStatus);
    }
  }

  Future<void> handleAuthentication(AuthenticationStatus status) async {
    // If no user credentials are stored, redirect to login page.
    if (!status.isAuthenticated) {
      return redirectToLogin();
    }

    // Use the stored user credentrials to load the user and all purchaseable
    // products, then redirect to home page if both were successfully loaded.
    return loadUserAndProducts
        .match(onUserOrProductsLoadFailed, redirectToHome)
        .run();
  }

  /// Handle the case where user credentials are stored but either the user or
  /// products could not be loaded.
  ///
  /// (this should not normally happen.)
  // TODO(marfavi): Find a better way to handle this.
  void onUserOrProductsLoadFailed() {
    final authenticationCubit = context.read<AuthenticationCubit>();
    authenticationCubit.unauthenticated();
    redirectToLogin();
  }

  /// A TaskOption that loads the user and purchasable products.
  ///
  /// Returns a [Some] with the products if both were successfully loaded,
  /// and [None] otherwise.
  TaskOption<PurchasableProducts> get loadUserAndProducts {
    return TaskOption(() async {
      final userCubit = context.read<UserCubit>();
      final productCubit = context.read<ProductCubit>();

      // Load and wait for both
      final _ = await Future.wait([
        userCubit.initialize(),
        productCubit.getProducts(),
      ]);

      final userInitiallyLoaded = userCubit.state is UserInitiallyLoaded;
      final productState = productCubit.state;

      return userInitiallyLoaded && productState is ProductsLoaded
          ? some(productState.products)
          : none();
    });
  }

  /// Redirects the user to the login page based.
  /// The route (animation) is determined by the [firstNavigation] flag.
  void redirectToLogin() {
    final Route route;
    route = firstNavigation
        ? LoginPageEmail.routeFromSplash
        : LoginPageEmail.routeFromLogout;

    firstNavigation = false;

    // Replaces the whole navigation stack with the approriate route.
    widget.navigatorKey.currentState!
        .pushAndRemoveUntil(route, (_) => false)
        .ignore();
  }

  /// Redirects the user to the home page.
  void redirectToHome(PurchasableProducts products) {
    final route = HomePage.routeWith(products: products);
    widget.navigatorKey.currentState!
        .pushAndRemoveUntil(route, (_) => false)
        .ignore();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EnvironmentCubit, EnvironmentState>(
          listener: (_, __) => onAuthenticationOrEnvironmentChange(),
        ),
        BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (_, __) => onAuthenticationOrEnvironmentChange(),
        ),
      ],
      // The colored container prevents brief black flashes
      // during page transitions
      child: ColoredBox(color: AppColors.primary, child: widget.child),
    );
  }
}
