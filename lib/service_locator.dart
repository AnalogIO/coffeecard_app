import 'package:chopper/chopper.dart';
import 'package:coffeecard/core/api_uri_constants.dart';
import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/core/external/screen_brightness.dart';
import 'package:coffeecard/core/firebase_analytics_event_logging.dart';
import 'package:coffeecard/core/ignore_value.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/core/store_utils.dart';
import 'package:coffeecard/env/env.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:coffeecard/features/contributor/data/datasources/contributor_local_data_source.dart';
import 'package:coffeecard/features/contributor/domain/usecases/fetch_contributors.dart';
import 'package:coffeecard/features/contributor/presentation/cubit/contributor_cubit.dart';
import 'package:coffeecard/features/environment/data/datasources/environment_remote_data_source.dart';
import 'package:coffeecard/features/environment/domain/usecases/get_environment_type.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/leaderboard/data/datasources/leaderboard_remote_data_source.dart';
import 'package:coffeecard/features/leaderboard/domain/usecases/get_leaderboard.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/features/login/domain/usecases/login_user.dart';
import 'package:coffeecard/features/login/domain/usecases/resend_email.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/features/occupation/domain/usecases/get_occupations.dart';
import 'package:coffeecard/features/occupation/presentation/cubit/occupation_cubit.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_local_data_source.dart';
import 'package:coffeecard/features/opening_hours/data/repositories/opening_hours_repository_impl.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/get_opening_hours.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:coffeecard/features/product.dart';
import 'package:coffeecard/features/purchase/data/datasources/purchase_remote_data_source.dart';
import 'package:coffeecard/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:coffeecard/features/receipt/data/repositories/receipt_repository_impl.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:coffeecard/features/receipt/domain/usecases/get_receipts.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/register/data/datasources/register_remote_data_source.dart';
import 'package:coffeecard/features/register/domain/usecases/register_user.dart';
import 'package:coffeecard/features/register/presentation/cubit/register_cubit.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/domain/usecases/consume_ticket.dart';
import 'package:coffeecard/features/ticket/domain/usecases/load_tickets.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/domain/usecases/get_user.dart';
import 'package:coffeecard/features/user/domain/usecases/request_account_deletion.dart';
import 'package:coffeecard/features/user/domain/usecases/update_user_details.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/features/voucher/data/datasources/voucher_remote_data_source.dart';
import 'package:coffeecard/features/voucher/domain/usecases/redeem_voucher_code.dart';
import 'package:coffeecard/features/voucher/presentation/cubit/voucher_cubit.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    hide $JsonSerializableConverter;
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart'
    hide $JsonSerializableConverter;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

final GetIt sl = GetIt.instance;

void configureServices() {
  ignoreValue(sl.registerSingleton(Logger()));

  initFeatures();
  initExternal();

  // Reactivation authenticator (uninitalized), http client and interceptors
  initHttp();

  // provide the account repository to the reactivation authenticator
  sl<RetryAuthenticator>().initialize(sl<AccountRemoteDataSource>());
}

void initExternal() {
  ignoreValue(sl.registerSingleton(const FlutterSecureStorage()));

  ignoreValue(sl.registerFactory(() => DateService()));
  ignoreValue(sl.registerFactory(() => ScreenBrightness()));
  ignoreValue(sl.registerLazySingleton(() => ExternalUrlLauncher()));

  ignoreValue(
    sl.registerSingleton<FirebaseAnalyticsEventLogging>(
      FirebaseAnalyticsEventLogging(FirebaseAnalytics.instance),
    ),
  );

  sl.registerLazySingleton(
    () => NetworkRequestExecutor(
      logger: sl(),
      firebaseLogger: sl(),
    ),
  );
}

void initFeatures() {
  initAuthentication();
  initOpeningHours();
  initOccupation();
  initUser();
  initReceipt();
  initTicket();
  initContributor();
  initPayment();
  initLeaderboard();
  initEnvironment();
  initProduct();
  initVoucher();
  initLogin();
  initRegister();
}

void initAuthentication() {
  // bloc
  sl.registerLazySingleton(
    () => AuthenticationCubit(sl()),
  );

  // repository
  sl.registerLazySingletonAsync<AuthenticationRepository>(
    () async => AuthenticationRepository(
      store: await Hive.openEncryptedBox<AuthenticationInfo>('auth').run(),
      logger: sl(),
    ),
  );
}

void initOpeningHours() {
  // bloc
  sl.registerFactory(
    () => OpeningHoursCubit(fetchOpeningHours: sl()),
  );

  // use case
  sl.registerFactory(() => GetOpeningHours(repository: sl()));

  // data source
  sl.registerLazySingleton<OpeningHoursLocalDataSource>(
    () => OpeningHoursLocalDataSource(),
  );

  // repository
  sl.registerFactory<OpeningHoursRepository>(
    () => OpeningHoursRepositoryImpl(
      dataSource: sl(),
      dateService: sl(),
    ),
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
  sl.registerFactory(
    () => LoadTickets(
      ticketRemoteDataSource: sl(),
      productRepository: sl(),
    ),
  );
  sl.registerFactory(() => ConsumeTicket(ticketRemoteDataSource: sl()));

  // data source
  sl.registerLazySingleton(
    () => TicketRemoteDataSource(
      api: sl(),
      executor: sl(),
    ),
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

void initContributor() {
  // bloc
  sl.registerFactory(() => ContributorCubit(fetchContributors: sl()));

  // use case
  sl.registerFactory(() => FetchContributors(dataSource: sl()));

  // data source
  sl.registerLazySingleton(() => ContributorLocalDataSource());
}

void initPayment() {
  // bloc

  // data source
  sl.registerFactory(
    () => PurchaseRemoteDataSource(
      apiV2: sl<CoffeecardApiV2>(),
      executor: sl<NetworkRequestExecutor>(),
    ),
  );
}

void initLeaderboard() {
  // bloc
  sl.registerFactory(
    () => LeaderboardCubit(getLeaderboard: sl()),
  );

  // use case
  sl.registerFactory(() => GetLeaderboard(remoteDataSource: sl()));

  // data source
  sl.registerLazySingleton(
    () => LeaderboardRemoteDataSource(apiV2: sl(), executor: sl()),
  );
}

void initEnvironment() {
  // bloc
  sl.registerLazySingleton(() => EnvironmentCubit(getEnvironmentType: sl()));

  // use case
  sl.registerFactory(() => GetEnvironmentType(remoteDataSource: sl()));

  // data source
  sl.registerLazySingleton(
    () => EnvironmentRemoteDataSource(
      apiV2: sl(),
      executor: sl(),
    ),
  );
}

void initProduct() {
  // bloc
  sl.registerFactory(() => ProductCubit(productRepository: sl()));

  // repository
  sl.registerLazySingleton(() => ProductRepository(api: sl(), executor: sl()));
}

void initVoucher() {
  // bloc
  sl.registerFactory(() => VoucherCubit(redeemVoucherCode: sl()));

  // use case
  sl.registerFactory(() => RedeemVoucherCode(dataSource: sl()));

  // data source
  sl.registerLazySingleton(
    () => VoucherRemoteDataSource(api: sl(), executor: sl()),
  );
}

void initLogin() {
  // bloc

  // use case
  sl.registerFactory(() => LoginUser(remoteDataSource: sl()));
  sl.registerFactory(() => ResendEmail(remoteDataSource: sl()));

  // data source
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSource(
      apiV1: sl(),
      apiV2: sl(),
      executor: sl(),
    ),
  );
}

void initRegister() {
  // bloc
  sl.registerFactory(
    () => RegisterCubit(
      registerUser: sl(),
      firebaseAnalyticsEventLogging: sl(),
    ),
  );

  // use case
  sl.registerFactory(() => RegisterUser(remoteDataSource: sl()));

  // data source
  sl.registerLazySingleton(
    () => RegisterRemoteDataSource(apiV2: sl(), executor: sl()),
  );
}

void initHttp() {
  ignoreValue(
    sl.registerSingleton<RetryAuthenticator>(
      RetryAuthenticator.uninitialized(
        repository: sl(),
        cubit: sl(),
        logger: sl(),
      ),
    ),
  );

  final coffeCardChopper = ChopperClient(
    baseUrl: Uri.parse(Env.coffeeCardUrl),
    interceptors: [AuthenticationInterceptor(sl())],
    converter: $JsonSerializableConverter(),
    services: [
      CoffeecardApi.create(),
      CoffeecardApiV2.create(),
    ],
    authenticator: sl.get<RetryAuthenticator>(),
  );

  final shiftplanningChopper = ChopperClient(
    baseUrl: ApiUriConstants.shiftyUrl,
    converter: $JsonSerializableConverter(),
    services: [ShiftplanningApi.create()],
  );

  ignoreValue(
    sl.registerSingleton<CoffeecardApi>(
      coffeCardChopper.getService<CoffeecardApi>(),
    ),
  );
  ignoreValue(
    sl.registerSingleton<CoffeecardApiV2>(
      coffeCardChopper.getService<CoffeecardApiV2>(),
    ),
  );
  ignoreValue(
    sl.registerSingleton<ShiftplanningApi>(
      shiftplanningChopper.getService<ShiftplanningApi>(),
    ),
  );
}
