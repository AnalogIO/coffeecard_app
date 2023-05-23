enum Environment {
  test,
  production,
  unknown,
}

extension EnvironmentIs on Environment {
  bool get isTest => this == Environment.test;
  bool get isProduction => this == Environment.production;
  bool get isUnknown => this == Environment.unknown;
}
