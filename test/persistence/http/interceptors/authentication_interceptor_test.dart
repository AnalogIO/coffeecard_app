import 'package:coffeecard/persistence/http/interceptors/authentication_interceptor.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SecureStorage])
void main() {
  group("AuthenticationInterceptor", () {
    test("AuthenticationInterceptor.onRequest() when token is not null adds a Authorization header", () async {
      // Arrange
      final mockSecureStorage = SecureStorage();
      when(mockSecureStorage.readToken()).thenAnswer((_) => Future.value("someToken"));

      final authenticationInterceptor = AuthenticationInterceptor(mockSecureStorage);

      final options = RequestOptions(path: "somePath");
      final handler = RequestInterceptorHandler();

      // Act
      await authenticationInterceptor.onRequest(options, handler);

      // Assert
      expect(options.headers["Authorization"], "Bearer someToken");
    });

    test("AuthenticationInterceptor.onRequest() when token is null does not add a Authorization header", () async {
      // Arrange
      final mockSecureStorage = SecureStorage();
      when(mockSecureStorage.readToken()).thenAnswer((_) => Future.value(null));

      final authenticationInterceptor = AuthenticationInterceptor(mockSecureStorage);

      final options = RequestOptions(path: "somePath");
      final handler = RequestInterceptorHandler();

      // Act
      await authenticationInterceptor.onRequest(options, handler);

      // Assert
      expect(options.headers["Authorization"], null);
    });
  });
}
