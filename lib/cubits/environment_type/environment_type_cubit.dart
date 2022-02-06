import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/app_config_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:equatable/equatable.dart';

part 'environment_type_state.dart';

class EnvironmentTypeCubit extends Cubit<EnvironmentTypeState> {
  final AppConfigRepository _configRepository = sl.get<AppConfigRepository>();
  EnvironmentTypeCubit()
      : super(
          const EnvironmentTypeState(
            status: DatabaseConnectionStatus.unknown,
          ),
        ) {
    getConfig();
  }

  Future<void> getConfig() async {
    final either = await _configRepository.getEnvironmentType();

    if (either.isRight) {
      final DatabaseConnectionStatus isConnectedToTestDB =
          either.right == 'Production'
              ? DatabaseConnectionStatus.production
              : DatabaseConnectionStatus.test;

      emit(EnvironmentTypeState(status: isConnectedToTestDB));
    } else {
      // if we cant connect to config endpoint, ignore
      emit(const EnvironmentTypeState(
          status: DatabaseConnectionStatus.production,),);
    }
  }

  Future<void> signalWidgetAdded() async {
    EnvironmentTypeState.widgetAdded = true;
    emit(EnvironmentTypeState(status: state.status));
  }
}
