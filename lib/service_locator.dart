import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/api/interceptors/authentication_interceptor.dart';
import 'package:coffeecard/data/repositories/external/contributor_repository.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/v1/occupation_repository.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/data/repositories/v1/receipt_repository.dart';
import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/data/repositories/v1/voucher_repository.dart';
import 'package:coffeecard/data/repositories/v2/app_config_repository.dart';
import 'package:coffeecard/data/repositories/v2/leaderboard_repository.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/env/env.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    hide $JsonSerializableConverter;
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart'
    hide $JsonSerializableConverter;
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:coffeecard/utils/reactivation_authenticator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final GetIt sl = GetIt.instance;

void configureServices() {
  // Logger
  sl.registerSingleton(Logger());

  // Executor
  sl.registerSingleton(Executor(sl<Logger>()));

  // Storage
  sl.registerSingleton(SecureStorage(sl<Logger>()));

  // Authentication
  sl.registerSingleton<AuthenticationCubit>(
    AuthenticationCubit(sl.get<SecureStorage>()),
  );

  sl.registerFactory<ReactivationAuthenticator>(
    () => ReactivationAuthenticator(sl),
  );

  // Features
  initFeatures();

  // Rest Client, Chopper client
  final coffeCardChopper = ChopperClient(
    baseUrl: Env.coffeeCardUrl,
    interceptors: [AuthenticationInterceptor(sl<SecureStorage>())],
    converter: $JsonSerializableConverter(),
    services: [
      CoffeecardApi.create(),
      CoffeecardApiV2.create(),
    ],
    authenticator: sl.get<ReactivationAuthenticator>(),
  );

  final shiftplanningChopper = ChopperClient(
    baseUrl: ApiUriConstants.shiftyUrl.toString(),
    converter: $JsonSerializableConverter(),
    services: [ShiftplanningApi.create()],
    authenticator: sl.get<ReactivationAuthenticator>(),
  );

  sl.registerSingleton<CoffeecardApi>(
    coffeCardChopper.getService<CoffeecardApi>(),
  );
  sl.registerSingleton<CoffeecardApiV2>(
    coffeCardChopper.getService<CoffeecardApiV2>(),
  );
  sl.registerSingleton<ShiftplanningApi>(
    shiftplanningChopper.getService<ShiftplanningApi>(),
  );

  // Repositories
  // v1
  sl.registerFactory<OccupationRepository>(
    () => OccupationRepository(
      apiV1: sl<CoffeecardApi>(),
      executor: sl<Executor>(),
    ),
  );

  sl.registerFactory<ReceiptRepository>(
    () => ReceiptRepository(
      apiV1: sl<CoffeecardApi>(),
      executor: sl<Executor>(),
    ),
  );

  sl.registerFactory<ProductRepository>(
    () => ProductRepository(
      apiV1: sl<CoffeecardApi>(),
      executor: sl<Executor>(),
    ),
  );

  sl.registerFactory<VoucherRepository>(
    () => VoucherRepository(
      apiV1: sl<CoffeecardApi>(),
      executor: sl<Executor>(),
    ),
  );

  // v1 and v2
  sl.registerFactory<TicketRepository>(
    () => TicketRepository(
      apiV1: sl<CoffeecardApi>(),
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<Executor>(),
    ),
  );

  sl.registerFactory<AccountRepository>(
    () => AccountRepository(
      apiV1: sl<CoffeecardApi>(),
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<Executor>(),
    ),
  );

  // v2
  sl.registerFactory<LeaderboardRepository>(
    () => LeaderboardRepository(
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<Executor>(),
    ),
  );

  sl.registerFactory<PurchaseRepository>(
    () => PurchaseRepository(
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<Executor>(),
    ),
  );

  sl.registerFactory<AppConfigRepository>(
    () => AppConfigRepository(
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<Executor>(),
    ),
  );

  // external
  sl.registerFactory<ContributorRepository>(
    ContributorRepository.new,
  );

  sl.registerSingleton<FirebaseAnalyticsEventLogging>(
    FirebaseAnalyticsEventLogging(FirebaseAnalytics.instance),
  );
}

void initFeatures() {
  initOpeningHours();
}

void initOpeningHours() {
  // bloc
  sl.registerFactory(
    () => OpeningHoursCubit(
      fetchOpeningHours: sl(),
      isOpen: sl(),
    ),
  );

  // use case
  sl.registerFactory(() => GetOpeningHours(repository: sl()));
  sl.registerFactory(() => CheckOpenStatus(repository: sl()));

  // repository
  sl.registerLazySingleton<OpeningHoursRepository>(
    () => OpeningHoursRepositoryImpl(dataSource: sl()),
  );

  // data source
  sl.registerLazySingleton<OpeningHoursRemoteDataSource>(
    () => OpeningHoursRemoteDataSourceImpl(api: sl()),
  );
}
