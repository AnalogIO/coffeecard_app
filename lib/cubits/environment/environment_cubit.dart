import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/app_config_repository.dart';

part 'environment_state.dart';

class EnvironmentCubit extends Cubit<Environment> {
  EnvironmentCubit(this._configRepository) : super(Environment.unknown);

  final AppConfigRepository _configRepository;

  Future<void> getConfig() async {
    final either = await _configRepository.getEnvironmentType();

    if (either.isRight) {
      final env = either.right == 'Production'
          ? Environment.production
          : Environment.test;
      emit(env);
    } else {
      // if we cant connect to config endpoint, ignore
      // FIXME: Don't do this! Should retry/display error to user.
      emit(Environment.production);
    }
  }
}
