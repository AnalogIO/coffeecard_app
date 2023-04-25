import 'package:chopper/chopper.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/api/interceptors/authentication_interceptor.dart';
import 'package:coffeecard/data/repositories/external/contributor_repository.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/data/repositories/v1/voucher_repository.dart';
import 'package:coffeecard/data/repositories/v2/app_config_repository.dart';
import 'package:coffeecard/data/repositories/v2/leaderboard_repository.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/env/env.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/features/occupation/domain/usecases/get_occupations.dart';
import 'package:coffeecard/features/occupation/presentation/cubit/occupation_cubit.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:coffeecard/features/receipt/data/repositories/receipt_repository_impl.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:coffeecard/features/receipt/domain/usecases/get_receipts.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/domain/usecases/consume_ticket.dart';
import 'package:coffeecard/features/ticket/domain/usecases/load_tickets.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/domain/usecases/get_user.dart';
import 'package:coffeecard/features/user/domain/usecases/request_account_deletion.dart';
import 'package:coffeecard/features/user/domain/usecases/update_user_details.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
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
  sl.registerLazySingleton(
    () => NetworkRequestExecutor(
      logger: sl(),
      firebaseLogger: sl(),
    ),
  );

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
    baseUrl: Uri.parse(Env.coffeeCardUrl),
    interceptors: [AuthenticationInterceptor(sl<SecureStorage>())],
    converter: $JsonSerializableConverter(),
    services: [
      CoffeecardApi.create(),
      CoffeecardApiV2.create(),
    ],
    authenticator: sl.get<ReactivationAuthenticator>(),
  );

  final shiftplanningChopper = ChopperClient(
    baseUrl: ApiUriConstants.shiftyUrl,
    converter: $JsonSerializableConverter(),
    services: [ShiftplanningApi.create()],
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
  sl.registerFactory<ProductRepository>(
    () => ProductRepository(
      apiV1: sl<CoffeecardApi>(),
      executor: sl<NetworkRequestExecutor>(),
    ),
  );

  sl.registerFactory<VoucherRepository>(
    () => VoucherRepository(
      apiV1: sl<CoffeecardApi>(),
      executor: sl<NetworkRequestExecutor>(),
    ),
  );

  // v1 and v2
  sl.registerFactory<AccountRepository>(
    () => AccountRepository(
      apiV1: sl<CoffeecardApi>(),
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<NetworkRequestExecutor>(),
    ),
  );

  // v2
  sl.registerFactory<LeaderboardRepository>(
    () => LeaderboardRepository(
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<NetworkRequestExecutor>(),
    ),
  );

  sl.registerFactory<PurchaseRepository>(
    () => PurchaseRepository(
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<NetworkRequestExecutor>(),
    ),
  );

  sl.registerFactory<AppConfigRepository>(
    () => AppConfigRepository(
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<NetworkRequestExecutor>(),
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
  initTicket();
  initOccupation();
  initUser();
  initReceipt();
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
  sl.registerFactory(() => CheckOpenStatus(dataSource: sl()));

  // repository
  sl.registerLazySingleton<OpeningHoursRepository>(
    () => OpeningHoursRepositoryImpl(dataSource: sl()),
  );

  // data source
  sl.registerLazySingleton<OpeningHoursRemoteDataSource>(
    () => OpeningHoursRemoteDataSource(api: sl(), executor: sl()),
  );
}

void initTicket() {
  // bloc
  sl.registerFactory(
    () => TicketsCubit(loadTickets: sl(), consumeTicket: sl()),
  );
}

void initOccupation() {
  // bloc
  sl.registerFactory(
    () => OccupationCubit(getOccupations: sl()),
  );

  // use case
  sl.registerFactory(() => GetOccupations(dataSource: sl()));

  // data source
  sl.registerLazySingleton<OccupationRemoteDataSource>(
    () => OccupationRemoteDataSource(
      api: sl(),
      executor: sl(),
    ),
  );
}

void initUser() {
  // bloc
  sl.registerFactory(
    () => UserCubit(
      getUser: sl(),
      requestAccountDeletion: sl(),
      updateUserDetails: sl(),
    ),
  );

  // use case
  sl.registerFactory(() => LoadTickets(ticketRemoteDataSource: sl()));
  sl.registerFactory(() => ConsumeTicket(ticketRemoteDataSource: sl()));

  // data source
  sl.registerLazySingleton(
    () => TicketRemoteDataSource(apiV1: sl(), apiV2: sl(), executor: sl()),
  );

  sl.registerFactory(() => GetUser(dataSource: sl()));
  sl.registerFactory(() => RequestAccountDeletion(dataSource: sl()));
  sl.registerFactory(() => UpdateUserDetails(dataSource: sl()));

  // data source
  sl.registerLazySingleton(
    () => UserRemoteDataSource(
      apiV2: sl(),
      executor: sl(),
    ),
  );
}

void initReceipt() {
  // bloc
  sl.registerFactory(() => ReceiptCubit(getReceipts: sl()));

  // use case
  sl.registerFactory(() => GetReceipts(repository: sl()));

  // repository
  sl.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // data source
  sl.registerLazySingleton(
    () => ReceiptRemoteDataSource(apiV2: sl(), executor: sl()),
  );
}
