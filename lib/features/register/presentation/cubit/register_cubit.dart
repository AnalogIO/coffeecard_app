import 'package:coffeecard/features/register/domain/usecases/register_user.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUser registerUser;
  final FirebaseAnalyticsEventLogging firebaseAnalyticsEventLogging;

  RegisterCubit({
    required this.registerUser,
    required this.firebaseAnalyticsEventLogging,
  }) : super(RegisterInitial());

  Future<void> register(
    String name,
    String email,
    String passcode,
    int occupationId,
  ) async {
    final either = await registerUser(
      Params(
        name: name,
        email: email,
        encodedPasscode: encodePasscode(passcode),
        occupationId: occupationId,
      ),
    );

    either.fold(
      (error) => emit(RegisterError(error.reason)),
      (_) {
        emit(RegisterSuccess());
        firebaseAnalyticsEventLogging.signUpEvent();
      },
    );
  }
}
