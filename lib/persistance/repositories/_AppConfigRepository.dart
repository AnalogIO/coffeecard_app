import 'package:coffeecard/model/AppConfig.dart';
import 'package:coffeecard/persistance/http/RestClient.dart';
import 'package:coffeecard/persistance/repositories/AppConfigRepository.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class _AppConfigRepository implements AppConfigRepository {

  final RestClient _restClient;
  final Logger _logger;

  _AppConfigRepository(this._restClient, this._logger);

  @override
  Future<AppConfig> getAppConfig() async {
    return await _restClient.getAppConfig().catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final httpResponse = (obj as DioError).response;
          _logger.e("API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
              break;
      }
    });
  }
}