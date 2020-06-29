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
    var login = Login(userName, password, "");

    var token = await _restClient.login(login).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final httpResponse = (obj as DioError).response;
          _logger.e(
              "API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
          break;
      }
    });

    await _storage.saveToken(token.token);
  }
}
