import 'package:chopper/chopper.dart';
import 'package:coffeecard/data/api/coffee_card_api_constants.dart';
import 'package:coffeecard/data/api/interceptors/authentication_interceptor.dart';
import 'package:coffeecard/data/repositories/account_repository.dart';
import 'package:coffeecard/data/repositories/app_config_repository.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart'
    hide $JsonSerializableConverter;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final GetIt sl = GetIt.instance;

void configureServices() {
  // Logger
  sl.registerSingleton(Logger());

  // Storage
  sl.registerSingleton(SecureStorage(sl<Logger>()));

  // Rest Client, Chopper client
  final _chopper = ChopperClient(
    baseUrl: CoffeeCardApiConstants.testUrl,
    // TODO load the url from config files
    interceptors: [AuthenticationInterceptor(sl<SecureStorage>())],
    converter: $JsonSerializableConverter(),
    services: [CoffeecardApi.create(), CoffeecardApiV2.create()],
  );

  sl.registerSingleton<CoffeecardApi>(_chopper.getService<CoffeecardApi>());
  sl.registerSingleton<CoffeecardApiV2>(_chopper.getService<CoffeecardApiV2>());

  // Repositories
  sl.registerFactory<AccountRepository>(
    () => AccountRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  sl.registerFactory<AppConfigRepository>(
    () => AppConfigRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  sl.registerFactory<PurchaseRepository>(
    () => PurchaseRepository(sl<CoffeecardApiV2>(), sl<Logger>()),
  );
}
