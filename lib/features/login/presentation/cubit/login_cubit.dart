import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/features/login/domain/usecases/login_user.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final String email;
  final AuthenticationCubit authenticationCubit;
  final LoginUser loginUser;
  final FirebaseAnalyticsEventLogging firebaseAnalyticsEventLogging;

  LoginCubit({
    required this.email,
    required this.authenticationCubit,
    required this.loginUser,
    required this.firebaseAnalyticsEventLogging,
  }) : super(const LoginTypingPasscode(''));

  void addPasscodeInput(String input) {
    final st = state;

    final String newPasscode;
    newPasscode = st is LoginTypingPasscode ? st.passcode + input : input;

    emit(LoginTypingPasscode(newPasscode));

    if (newPasscode.length == 4) _loginRequested();
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
      (error) => emit(LoginError(error.reason)),
      (user) {
        firebaseAnalyticsEventLogging.loginEvent();

        authenticationCubit.authenticated(
          user.email,
          encodedPasscode,
          user.token,
        );
      },
    );
  }
}
