import 'package:coffeecard/model/app_config.dart';
import 'package:coffeecard/persistence/http/coffee_card_api_client.dart';
import 'package:coffeecard/persistence/repositories/app_config_repository.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  final CoffeeCardApiClient _restClient;
  final Logger _logger;

  AppConfigRepositoryImpl(this._restClient, this._logger);

  @override
  Future<AppConfig> getAppConfig() async {
    try {
      return await _restClient.getAppConfig();
    } on DioError catch (error) {
      final httpResponse = error.response;
      _logger.e("API Error ${httpResponse?.statusCode} ${httpResponse?.statusMessage}");
      rethrow;
    }
  }
}
