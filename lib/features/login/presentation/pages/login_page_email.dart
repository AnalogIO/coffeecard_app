import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/validator/email_is_valid.dart';
import 'package:coffeecard/core/widgets/fast_slide_transition.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_base.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_passcode.dart';
import 'package:coffeecard/features/login/presentation/widgets/login_cta.dart';
import 'package:coffeecard/features/login/presentation/widgets/login_email_text_field.dart';
import 'package:coffeecard/features/register/presentation/pages/register_flow.dart';
import 'package:flutter/material.dart';

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
      // TODO: Send et kald der beder om et magic link
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

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ = _controller.forward();

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
