import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/api/coffee_card_api_constants.dart';
import 'package:coffeecard/data/api/interceptors/authentication_interceptor.dart';
import 'package:coffeecard/data/repositories/shiftplanning/opening_hours_repository.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/app_config_repository.dart';
import 'package:coffeecard/data/repositories/v1/coffeecard_repository.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/data/repositories/v1/receipt_repository.dart';
import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/data/repositories/v1/voucher_repository.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart'
    hide $JsonSerializableConverter;
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.swagger.dart'
    hide $JsonSerializableConverter;
import 'package:coffeecard/utils/reactivation_authenticator.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final GetIt sl = GetIt.instance;

void configureServices() {
  // Logger
  sl.registerSingleton(Logger());

  // Storage
  sl.registerSingleton(SecureStorage(sl<Logger>()));

  // Authentication
  sl.registerSingleton<AuthenticationCubit>(
    AuthenticationCubit(sl.get<SecureStorage>()),
  );

  sl.registerFactory<ReactivationAuthenticator>(
    () => ReactivationAuthenticator(sl),
  );

  // Rest Client, Chopper client
  final _coffeCardChopper = ChopperClient(
    baseUrl: CoffeeCardApiConstants.betav2Url,
    // TODO load the url from config files
    interceptors: [AuthenticationInterceptor(sl<SecureStorage>())],
    converter: $JsonSerializableConverter(),
    services: [
      CoffeecardApi.create(),
      CoffeecardApiV2.create(),
    ],
    authenticator: sl.get<ReactivationAuthenticator>(),
  );

  final _shiftplanningChopper = ChopperClient(
    baseUrl: CoffeeCardApiConstants.shiftyUrl,
    // TODO load the url from config files
    converter: $JsonSerializableConverter(),
    services: [ShiftplanningApi.create()],
    authenticator: sl.get<ReactivationAuthenticator>(),
  );

  sl.registerSingleton<CoffeecardApi>(
    _coffeCardChopper.getService<CoffeecardApi>(),
  );
  sl.registerSingleton<CoffeecardApiV2>(
    _coffeCardChopper.getService<CoffeecardApiV2>(),
  );
  sl.registerSingleton<ShiftplanningApi>(
    _shiftplanningChopper.getService<ShiftplanningApi>(),
  );

  // Repositories
  // v1
  sl.registerFactory<AccountRepository>(
    () => AccountRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  sl.registerFactory<ReceiptRepository>(
    () => ReceiptRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  sl.registerFactory<AppConfigRepository>(
    () => AppConfigRepository(sl<CoffeecardApiV2>(), sl<Logger>()),
  );

  sl.registerFactory<TicketRepository>(
    () => TicketRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  sl.registerFactory<CoffeeCardRepository>(
    () => CoffeeCardRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  sl.registerFactory<ProductRepository>(
    () => ProductRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  sl.registerFactory<LeaderboardRepository>(
    () => LeaderboardRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  sl.registerFactory<VoucherRepository>(
    () => VoucherRepository(sl<CoffeecardApi>(), sl<Logger>()),
  );

  // v2
  sl.registerFactory<PurchaseRepository>(
    () => PurchaseRepository(sl<CoffeecardApiV2>(), sl<Logger>()),
  );

  // shiftplanning
  sl.registerFactory<OpeningHoursRepository>(
    () => OpeningHoursRepository(sl<ShiftplanningApi>(), sl<Logger>()),
  );
}
