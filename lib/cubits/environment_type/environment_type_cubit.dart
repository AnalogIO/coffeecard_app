import 'package:bloc/bloc.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/app_config_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
    final String environment = await _configRepository.getEnvironmentType();

    final DatabaseConnectionStatus isConnectedToTestDB =
        environment == 'Production'
            ? DatabaseConnectionStatus.production
            : DatabaseConnectionStatus.test;

    emit(EnvironmentTypeState(status: isConnectedToTestDB));
  }

  Future<void> addTestDBWidget(BuildContext context) async {
    //Delay is required to trigger after build
    Future.delayed(Duration.zero, () {
      final entry = OverlayEntry(
        builder: (context) => IgnorePointer(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 100,
              child: Text(
                Strings.testDBString,
                style: TextStyle(color: Colors.red[900], fontSize: 20),
              ),
            ),
          ),
        ),
      );
      final overlay = Overlay.of(context);
      overlay?.insert(entry);
    });
    EnvironmentTypeState.widgetAdded = true;
    emit(EnvironmentTypeState(status: state.status));
  }
}
