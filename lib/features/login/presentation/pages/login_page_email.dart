import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/validator/email_is_valid.dart';
import 'package:coffeecard/core/widgets/fast_slide_transition.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/login/presentation/cubit/login_cubit.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_base.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_passcode.dart';
import 'package:coffeecard/features/login/presentation/widgets/login_cta.dart';
import 'package:coffeecard/features/login/presentation/widgets/login_email_text_field.dart';
import 'package:coffeecard/features/register/presentation/pages/register_flow.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class LoginPageEmail extends StatefulWidget {
  const LoginPageEmail({this.transitionDuration = Duration.zero});

  final Duration transitionDuration;

  static Route get routeFromSplash {
    const duration = Duration(milliseconds: 850);
    return FastSlideTransition(
      duration: duration,
      child: const LoginPageEmail(transitionDuration: duration),
    );
  }

  static Route get routeFromLogout {
    return FastSlideTransition(
      child: const LoginPageEmail(),
    );
  }

  @override
  State<LoginPageEmail> createState() => _LoginPageEmailState();
}

class _LoginPageEmailState extends State<LoginPageEmail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late LocalAuthentication _authentication;

  String? _error;
  String? get error => _error;
  set error(String? err) => setState(() => _error = err);

  void _register(BuildContext context) {
    error = null;
    final _ = Navigator.push(context, RegisterFlow.route);
  }

  void _resetError() => error = null;

  void _validateEmail(BuildContext context, String email) {
    if (email.isEmpty) {
      error = Strings.loginEnterEmailError;
    } else if (!emailIsValid(email)) {
      error = Strings.loginInvalidEmailError;
    } else {
      final _ =
          Navigator.push(context, LoginPagePasscode.routeWith(email: email));
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );

    _authentication = LocalAuthentication();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> theThing() async {
    final canAuthenticateWithBiometrics =
        await _authentication.canCheckBiometrics;
    final canAuthenticate = canAuthenticateWithBiometrics ||
        await _authentication.isDeviceSupported();

    return canAuthenticate;
  }

  @override
  Widget build(BuildContext context) {
    final _ = _controller.forward();

    final canAuthenticate = theThing();

    canAuthenticate.then((x) {
      if (!x) {
        return;
      }

      context.read<AuthenticationCubit>().getRegisteredUser().then((user) {
        user.match(
          () => null,
          (user) {
            _authentication
                .authenticate(localizedReason: 'Sign in?')
                .then((authenticated) {
              if (!authenticated) {
                return;
              }

              LoginCubit(
                email: user.email,
                loginUser: sl(),
                resendEmail: sl(),
                authenticationCubit: sl(),
                firebaseAnalyticsEventLogging: sl(),
              ).attemptLogin(user.encodedPasscode);
            });
          },
        );
      });
    });

    return FadeTransition(
      opacity: _animation,
      child: LoginPageBase(
        resizeToAvoidBottomInset: false,
        title: Strings.loginSignIn,
        inputWidget: LoginEmailTextField(
          hasError: error != null,
          autoFocusDelay: widget.transitionDuration,
          onSubmit: _validateEmail,
          onChange: _resetError,
        ),
        error: error,
        ctaChildren: [
          LoginCTA(text: Strings.loginCreateAccount, onPressed: _register),
        ],
      ),
    );
  }
}
