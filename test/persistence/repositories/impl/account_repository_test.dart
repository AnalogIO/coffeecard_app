import 'package:coffeecard/model/login.dart';
import 'package:coffeecard/model/token.dart';
import 'package:coffeecard/persistence/http/coffee_card_api_client.dart';
import 'package:coffeecard/persistence/repositories/impl/account_repository_impl.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

class MockCoffeeCardApiClient extends Mock implements CoffeeCardApiClient {}
class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group("AccountRepository", () {
    test("AccountRepository.login() given username and password calls RestClient", () async {
      // Arrange
      var mockClient = MockCoffeeCardApiClient();
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
      var mockClient = MockCoffeeCardApiClient();
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
      var mockClient = MockCoffeeCardApiClient();
      var mockStorage = MockSecureStorage();
      var repository = AccountRepositoryImpl(mockClient, Logger(), mockStorage);

      when(mockClient.login(any)).thenAnswer((_) => new Future.error(DioError(response: Response(statusCode: 400, statusMessage: "some error"))));

      // Act
      expect(
          () async => await repository.login("testmail@mail.com", "SomePassword"), throwsA(isInstanceOf<DioError>()));

      // Assert
      verifyNever(mockStorage.saveToken(any));
    });
  });
}