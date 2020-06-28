import 'package:coffeecard/model/Login.dart';
import 'package:coffeecard/model/Token.dart';
import 'package:coffeecard/persistence/http/RestClient.dart';
import 'package:coffeecard/persistence/repositories/impl/AccountRepositoryImpl.dart';
import 'package:coffeecard/persistence/storage/SecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

class MockRestClient extends Mock implements RestClient {}
class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group("AccountRepository", () {
    test("AccountRepository.login() given username and password calls RestClient", () async {
      // Arrange
      var mockClient = MockRestClient();
      var mockStorage = MockSecureStorage();
      var repository = AccountRepositoryImpl(mockClient, Logger(), mockStorage);

      when(mockClient.login(any)).thenAnswer((_) => Future.value(Token("empty")));

      // Act
      await repository.login("testmail@mail.com", "SomePassword");

      // Assert
      verify(mockClient.login(Login("testmail@mail.com", "SomePassword", "")));
    });

    test("AccountRepository.login() given username and password with a successful response from RestClient saves Token", () async {
      // Arrange
      var mockClient = MockRestClient();
      var mockStorage = MockSecureStorage();
      var repository = AccountRepositoryImpl(mockClient, Logger(), mockStorage);

      var token = Token("someToken");
      when(mockClient.login(any)).thenAnswer((_) => Future.value(token));

      // Act
      await repository.login("testmail@mail.com", "SomePassword");

      // Assert
      verify(mockStorage.saveToken(token.token));
    });

    test("AccountRepository.login() given username and password with a un-successful response from RestClient does not save Token", () async {
      // Arrange
      var mockClient = MockRestClient();
      var mockStorage = MockSecureStorage();
      var repository = AccountRepositoryImpl(mockClient, Logger(), mockStorage);

      when(mockClient.login(any)).thenAnswer((_) => new Future.error(DioError(response: Response(statusCode: 400, statusMessage: "some error"))));

      // Act
      await repository.login("testmail@mail.com", "SomePassword");

      // Assert
      verifyNever(mockStorage.saveToken(any));
    });
  });
}