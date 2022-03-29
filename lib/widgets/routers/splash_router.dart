import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/pages/splash_page.dart';
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

  void _authListener(BuildContext context, AuthenticationState state) {
    _authStatus = state.status;
    _maybeNavigate(context.read<EnvironmentCubit>().state);
  }

  void _envListener(BuildContext _, EnvironmentState state) {
    _maybeNavigate(state);
  }

  /// Navigates out of the splash screen if both
  /// _authStatus and _environment are loaded.
  void _maybeNavigate(EnvironmentState state) {
    if (_authStatus.isUnknown || state is! EnvironmentLoaded) return;
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
        BlocListener<EnvironmentCubit, EnvironmentState>(
          listener: _envListener,
        ),
        BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: _authListener,
        ),
      ],
      child: BlocBuilder<EnvironmentCubit, EnvironmentState>(
        builder: (context, state) {
          if (state is EnvironmentLoaded || state is EnvironmentInitial) {
            return widget.child;
          } else {
            return SplashPage(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Strings.noInternet,
                    style: AppTextStyle.explainerBright,
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(AppColor.primary),
                      maximumSize: MaterialStateProperty.all(Size.infinite),
                      backgroundColor:
                          MaterialStateProperty.all(AppColor.white),
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    onPressed: () async {
                      final environmentLoaded =
                          context.read<EnvironmentCubit>().getConfig();
                      LoadingOverlay.of(context).show();
                      //Delay since it is otherwise not obvious a load is happening with no internet
                      await Future.delayed(const Duration(milliseconds: 200));
                      await environmentLoaded;
                      //ignore: use_build_context_synchronously
                      LoadingOverlay.of(context).hide();
                    },
                    child: Text(
                      Strings.retry,
                      style: AppTextStyle.buttonTextDark,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
