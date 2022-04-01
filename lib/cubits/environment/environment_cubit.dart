import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v2/app_config_repository.dart';
import 'package:coffeecard/models/environment.dart';

part 'environment_state.dart';

class EnvironmentCubit extends Cubit<EnvironmentState> {
  EnvironmentCubit(this._configRepository) : super(EnvironmentInitial());

  final AppConfigRepository _configRepository;

  Future<void> getConfig() async {
    final either = await _configRepository.getEnvironmentType();

    if (either.isRight) {
      final isTest = either.right !=
          Environment.production; //TODO handle potential other types better
      emit(EnvironmentLoaded(isTestEnvironment: isTest));
    } else {
      emit(EnvironmentError());
    }
  }
}
