import 'package:coffeecard/persistence/storage/SecureStorage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  const _userTokenKey = "authentication_token";

  group("SecureStorage", () {
    test("SecureStorage.saveToken() given token saves token to FlutterSecureStorage", () async {
      var mockFlutterSecureStorage = MockFlutterSecureStorage();
      var secureStorage = SecureStorage(mockFlutterSecureStorage, Logger());

      await secureStorage.saveToken("someToken");

      verify(mockFlutterSecureStorage.write(key: _userTokenKey, value: "someToken"));
    });

    test("SecureStorage.readToken() reads token from FlutterSecureStorage", () async {
      var mockFlutterSecureStorage = MockFlutterSecureStorage();
      var secureStorage = SecureStorage(mockFlutterSecureStorage, Logger());

      await secureStorage.readToken();

      verify(mockFlutterSecureStorage.read(key: _userTokenKey));
    });
  });
}