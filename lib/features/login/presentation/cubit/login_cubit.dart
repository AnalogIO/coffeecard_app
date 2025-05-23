import 'package:coffeecard/core/encode_passcode.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/login/domain/errors/email_not_verified_failure.dart';
import 'package:coffeecard/features/login/domain/usecases/login_user.dart';
import 'package:coffeecard/features/login/domain/usecases/resend_email.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final String email;
  final AuthenticationCubit authenticationCubit;
  final LoginUser loginUser;
  final ResendEmail resendEmail;

  LoginCubit({
    required this.email,
    required this.authenticationCubit,
    required this.loginUser,
    required this.resendEmail,
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
        authenticationCubit.authenticated(
          user.email,
          encodedPasscode,
          user.token,
        );
      },
    );
  }
}
