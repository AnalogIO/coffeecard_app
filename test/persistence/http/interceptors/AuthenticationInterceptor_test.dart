import 'package:coffeecard/persistence/http/interceptors/AuthenticationInterceptor.dart';
import 'package:coffeecard/persistence/storage/SecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group("AuthenticationInterceptor", () {
    test("AuthenticationInterceptor.onRequest() when token is not null adds a Authorization header", () async {
      // Arrange
      var mockSecureStorage = MockSecureStorage();
      when(mockSecureStorage.readToken()).thenAnswer((_) => Future.value("someToken"));

      var authenticationInterceptor = AuthenticationInterceptor(mockSecureStorage);

      var options = RequestOptions();

      // Act
      await authenticationInterceptor.onRequest(options);

      // Assert
      expect(options.headers["Authorization"], "Bearer someToken");
    });

    test("AuthenticationInterceptor.onRequest() when token is null does not add a Authorization header", () async {
      // Arrange
      var mockSecureStorage = MockSecureStorage();
      when(mockSecureStorage.readToken()).thenAnswer((_) => Future.value(null));

      var authenticationInterceptor = AuthenticationInterceptor(mockSecureStorage);

      var options = RequestOptions();

      // Act
      await authenticationInterceptor.onRequest(options);

      // Assert
      expect(options.headers["Authorization"], null);
    });
  });
}
