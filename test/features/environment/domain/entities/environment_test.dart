import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromAppConfig', () {
    test(
      'should return [Production] when environment type is Production',
      () {
        // act
        final actual =
            Environment.fromAppConfig(AppConfig(environmentType: 'Production'));

        // assert
        expect(actual, Environment.production);
      },
    );

    test(
      'should return [Test] when environment type is Test',
      () {
        // act
        final actual =
            Environment.fromAppConfig(AppConfig(environmentType: 'Test'));

        // assert
        expect(actual, Environment.test);
      },
    );

    test(
      'should return [Test] when environment type is LocalDevelopment',
      () {
        // act
        final actual = Environment.fromAppConfig(
          AppConfig(environmentType: 'LocalDevelopment'),
        );

        // assert
        expect(actual, Environment.test);
      },
    );

    test(
      'should return [Unknown] when environment type cannot be parsed',
      () {
        // act
        final actual =
            Environment.fromAppConfig(AppConfig(environmentType: ''));

        // assert
        expect(actual, Environment.unknown);
      },
    );
  });
}
