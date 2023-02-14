import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  AccountRepository repository;

  RegisterCubit({required this.repository}) : super(RegisterInitial());

  Future<void> register(
    String name,
    String email,
    String passcode,
    int occupationId,
  ) async {
    final either = await repository.register(
      name,
      email,
      encodePasscode(passcode),
      occupationId,
    );

    either.fold(
      (error) => emit(RegisterError(error.message)),
      (_) {
        emit(RegisterSuccess());
        sl<FirebaseAnalyticsEventLogging>().signUpEvent();
      },
    );
  }
}
