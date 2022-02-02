import 'package:bloc/bloc.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/app_config_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'database_connection_state.dart';

class DatabaseConnectionCubit extends Cubit<DatabaseConnectionState> {
  final AppConfigRepository _configRepository = sl.get<AppConfigRepository>();

  DatabaseConnectionCubit()
      : super(
          const DatabaseConnectionState(
            status: DatabaseConnectionStatus.unknown,
          ),
        ) {
    getConfig();
  }

  Future<void> getConfig() async {
    //FIXME: uncomment once data is available
    await Future.delayed(const Duration(seconds: 1));
    //final AppConfigDto config = await _configRepository.getAppConfig();

    //final bool isConnectedToTestDB = config.environmentType != 'Production';

    //emit(DatabaseConnectionLoaded(isTest: isConnectedToTestDB));
    emit(const DatabaseConnectionState(status: DatabaseConnectionStatus.test));
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
    DatabaseConnectionState.widgetAdded = true;
    emit(DatabaseConnectionState(status: state.status));
  }
}
