import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v2/app_config_repository.dart';
import 'package:coffeecard/models/environment.dart';
import 'package:equatable/equatable.dart';

part 'environment_state.dart';

class EnvironmentCubit extends Cubit<EnvironmentState> {
  EnvironmentCubit(this._configRepository) : super(const EnvironmentInitial());

  final AppConfigRepository _configRepository;

  Future<void> getConfig() async {
    final either = await _configRepository.getEnvironmentType();

    either.fold(
      (error) => emit(EnvironmentError(error.reason)),
      (env) => emit(EnvironmentLoaded(env: env)),
    );
  }
}
