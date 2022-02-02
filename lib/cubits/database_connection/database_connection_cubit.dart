import 'package:bloc/bloc.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/app_config_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart';
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
    final AppConfig config = await _configRepository.getAppConfig();

    final DatabaseConnectionStatus isConnectedToTestDB =
        config.environmentType == 'Production'
            ? DatabaseConnectionStatus.production
            : DatabaseConnectionStatus.test;

    emit(DatabaseConnectionState(status: isConnectedToTestDB));
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
