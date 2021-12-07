import 'package:coffeecard/model/app_config.dart';

abstract class AppConfigRepository {
  Future<AppConfig> getAppConfig();
}
