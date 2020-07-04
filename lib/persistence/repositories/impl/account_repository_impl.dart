import 'package:coffeecard/model/login.dart';
import 'package:coffeecard/persistence/http/coffee_card_api_client.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AccountRepositoryImpl implements AccountRepository {
  final CoffeeCardApiClient _restClient;
  final Logger _logger;
  final SecureStorage _storage;

  AccountRepositoryImpl(this._restClient, this._logger, this._storage);

  @override
  Future login(String userName, String password) async {
    // TODO (jar): Handle or disable app versioning for API calls
    var login = Login(userName, password, "2.0.0");

    try {
      var token = await _restClient.login(login);
      await _storage.saveToken(token.token);
    } on DioError catch (error) {
      final httpResponse = error.response;
      _logger.e("API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
      rethrow;
    }
  }
}
