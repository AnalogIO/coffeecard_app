import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/environment.dart';
import 'package:equatable/equatable.dart';

part 'environment_state.dart';

class EnvironmentCubit extends Cubit<EnvironmentState> {
  EnvironmentCubit({required EnvironmentRepository repository})
      : _repository = repository,
        super(const EnvironmentLoading());

  final EnvironmentRepository _repository;

  Future<void> loadEnvironment() {
    emit(const EnvironmentLoading());
    return _repository
        .getEnvironment()
        .match(
          (failure) => EnvironmentLoadError(failure.reason),
          EnvironmentLoaded.new,
        )
        .map(emit)
        .run();
  }
}
