import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';

enum Environment {
  test,
  production,
  unknown;

  static Environment fromAppConfig(AppConfig config) {
    final type = environmentTypeFromJson(config.environmentType as String);

    return switch (type) {
      EnvironmentType.production => Environment.production,
      EnvironmentType.test ||
      EnvironmentType.localdevelopment =>
        Environment.test,
      EnvironmentType.swaggerGeneratedUnknown => Environment.unknown,
    };
  }
}

extension EnvironmentExtensions on Environment {
  bool get isTest => this == Environment.test;
  bool get isProduction => this == Environment.production;
  bool get isUnknown => this == Environment.unknown;
}
