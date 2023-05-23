import 'package:bloc/bloc.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/domain/usecases/get_environment_type.dart';
import 'package:equatable/equatable.dart';

part 'environment_state.dart';

class EnvironmentCubit extends Cubit<EnvironmentState> {
  final GetEnvironmentType getEnvironmentType;

  EnvironmentCubit({required this.getEnvironmentType})
      : super(const EnvironmentInitial());

  Future<void> getConfig() async {
    final either = await getEnvironmentType(NoParams());

    either.fold(
      (error) => emit(EnvironmentError(error.reason)),
      (env) => emit(EnvironmentLoaded(env: env)),
    );
  }
}
