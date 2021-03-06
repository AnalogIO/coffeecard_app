import 'package:coffeecard/persistence/http/coffee_card_api_client.dart';
import 'package:coffeecard/persistence/http/interceptors/authentication_interceptor.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/persistence/repositories/app_config_repository.dart';
import 'package:coffeecard/persistence/repositories/impl/account_repository_impl.dart';
import 'package:coffeecard/persistence/repositories/impl/app_config_repository_impl.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final GetIt sl = GetIt.instance;

void configureServices() {
  // Logger
  sl.registerSingleton(Logger());

  // Storage
  sl.registerSingleton(SecureStorage(FlutterSecureStorage(), sl<Logger>()));

  // Rest Client, Dio http client
  var _dio = Dio();
  _dio.interceptors.add(AuthenticationInterceptor(sl<SecureStorage>()));
  _dio.options.connectTimeout = 30000; // 30s
  _dio.options.receiveTimeout = 30000; // 30s

  sl.registerSingleton<CoffeeCardApiClient>(CoffeeCardApiClient(_dio, baseUrl: CoffeeCardApiClient.testUrl));

  // Repositories
  sl.registerFactory<AccountRepository>(
      () => AccountRepositoryImpl(sl<CoffeeCardApiClient>(), sl<Logger>(), sl<SecureStorage>()));
  sl.registerFactory<AppConfigRepository>(() => AppConfigRepositoryImpl(sl<CoffeeCardApiClient>(), sl<Logger>()));
}
