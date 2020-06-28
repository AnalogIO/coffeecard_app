import 'package:coffeecard/persistence/http/RestClient.dart';
import 'package:coffeecard/persistence/http/interceptors/AuthenticationInterceptor.dart';
import 'package:coffeecard/persistence/repositories/AccountRepository.dart';
import 'package:coffeecard/persistence/repositories/AppConfigRepository.dart';
import 'package:coffeecard/persistence/repositories/impl/AccountRepositoryImpl.dart';
import 'package:coffeecard/persistence/repositories/impl/AppConfigRepositoryImpl.dart';
import 'package:coffeecard/persistence/storage/SecureStorage.dart';
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

  sl.registerSingleton<RestClient>(RestClient(_dio, baseUrl: RestClient.DEBUG_URL));

  // Repositories
  sl.registerFactory<AccountRepository>(
      () => AccountRepositoryImpl(sl<RestClient>(), sl<Logger>(), sl<SecureStorage>()));
  sl.registerFactory<AppConfigRepository>(() => AppConfigRepositoryImpl(sl<RestClient>(), sl<Logger>()));
}
