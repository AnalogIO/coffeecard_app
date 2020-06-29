import 'package:coffeecard/model/app_config.dart';
import 'package:coffeecard/persistence/http/rest_client.dart';
import 'package:coffeecard/persistence/repositories/app_config_repository.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  final RestClient _restClient;
  final Logger _logger;

  AppConfigRepositoryImpl(this._restClient, this._logger);

  @override
  Future<AppConfig> getAppConfig() async {
    return await _restClient.getAppConfig().catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final httpResponse = (obj as DioError).response;
          _logger.e(
              "API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
          break;
      }
    });
  }
}
