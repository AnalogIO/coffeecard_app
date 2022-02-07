part of 'environment_cubit.dart';

enum Environment { unknown, test, production }

extension EnvironmentIs on Environment {
  bool get isUnknown => this == Environment.unknown;
  bool get isTest => this == Environment.test;
  bool get isProduction => this == Environment.production;
}
