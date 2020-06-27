import 'package:coffeecard/model/Login.dart';
import 'package:coffeecard/persistance/http/RestClient.dart';
import 'package:coffeecard/persistance/repositories/AccountRepository.dart';
import 'package:coffeecard/persistance/storage/SecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class _AccountRepository implements AccountRepository {
  final RestClient _restClient;
  final Logger _logger;
  final SecureStorage _storage;

  _AccountRepository(this._restClient, this._logger, this._storage);

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
