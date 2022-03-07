import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/app_config_repository.dart';

part 'environment_state.dart';

class EnvironmentCubit extends Cubit<EnvironmentState> {
  EnvironmentCubit(this._configRepository) : super(EnvironmentInitial());

  final AppConfigRepository _configRepository;

  Future<void> getConfig() async {
    final either = await _configRepository.getEnvironmentType();

    if (either.isRight) {
      final isTest = either.right != 'Production';
      emit(EnvironmentLoaded(isTestEnvironment: isTest));
    } else {
      // FIXME: Handle error
      emit(EnvironmentError());
    }
  }
}
