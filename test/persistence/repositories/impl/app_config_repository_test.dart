import 'package:coffeecard/model/app_config.dart';
import 'package:coffeecard/persistence/http/coffee_card_api_client.dart';
import 'package:coffeecard/persistence/repositories/impl/app_config_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

class MockCoffeeCardApiClient extends Mock implements CoffeeCardApiClient {}

void main() {
  group("AppConfigRepository", () {
    test("AppConfigRepository.getAppConfig() calls RestClient", () async {
      // Arrange
      final mockClient = MockCoffeeCardApiClient();
      final repository = AppConfigRepositoryImpl(mockClient, Logger());

      when(mockClient.getAppConfig()).thenAnswer((_) => Future.value(AppConfig(EnvironmentType.test, "APPDK")));

      // Act
      await repository.getAppConfig();

      // Assert
      verify(mockClient.getAppConfig());
    });

    test("AppConfigRepository.getAppConfig() calling RestClient throwing Error rethrows Error", () async {
      // Arrange
      final mockClient = MockCoffeeCardApiClient();
      final repository = AppConfigRepositoryImpl(mockClient, Logger());

      when(mockClient.getAppConfig()).thenAnswer((_) => Future.error(DioError(response: Response(statusCode: 400, statusMessage: "some error"))));

      // Act, Assert
      expect(() async => repository.getAppConfig(), throwsA(isInstanceOf<DioError>()));
    });
  });
}