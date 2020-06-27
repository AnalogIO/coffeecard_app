import 'package:coffeecard/model/AppConfig.dart';

abstract class AppConfigRepository {
  Future<AppConfig> getAppConfig();
}