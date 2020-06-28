import 'package:coffeecard/model/Login.dart';
import 'package:coffeecard/persistence/http/RestClient.dart';
import 'package:coffeecard/persistence/repositories/AccountRepository.dart';
import 'package:coffeecard/persistence/storage/SecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AccountRepositoryImpl implements AccountRepository {
  final RestClient _restClient;
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
