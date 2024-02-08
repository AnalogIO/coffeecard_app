import 'package:coffeecard/core/encode_passcode.dart';
import 'package:coffeecard/core/firebase_analytics_event_logging.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:coffeecard/features/login.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final String email;
  final AuthenticationCubit authenticationCubit;
  final LoginUser loginUser;
  final ResendEmail resendEmail;
  final FirebaseAnalyticsEventLogging firebaseAnalyticsEventLogging;

  LoginCubit({
    required this.email,
    required this.authenticationCubit,
    required this.loginUser,
    required this.resendEmail,
    required this.firebaseAnalyticsEventLogging,
  }) : super(const LoginTypingPasscode(''));

  void addPasscodeInput(String input) {
    final st = state;

    final String newPasscode;
    newPasscode = st is LoginTypingPasscode ? st.passcode + input : input;

    emit(LoginTypingPasscode(newPasscode));

    if (newPasscode.length == 4) _loginRequested();
  }

  Future<void> resendVerificationEmail(String email) async {
    final either = await resendEmail(email);

    return either.fold(
      (err) => emit(LoginError(err.reason)),
      (_) => clearPasscode(),
    );
  }

  void clearPasscode() {
    emit(const LoginTypingPasscode(''));
  }

  Future<void> _loginRequested() async {
    final passcode = (state as LoginTypingPasscode).passcode;
    final encodedPasscode = encodePasscode(passcode);

    emit(const LoginLoading());

    final either = await loginUser(
      email: email,
      encodedPasscode: encodedPasscode,
    );

    either.fold(
      (error) {
        if (error is EmailNotVerifiedFailure) {
          emit(LoginEmailNotVerified(error.reason));
          return;
        }

        emit(LoginError(error.reason));
      },
      (user) {
        firebaseAnalyticsEventLogging.loginEvent();

        authenticationCubit.authenticated(
          AuthenticationInfo(
            email: user.email,
            encodedPasscode: encodedPasscode,
            token: user.token,
          ),
        );
      },
    );
  }
}
