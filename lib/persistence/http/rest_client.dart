import 'package:coffeecard/model/app_config.dart';
import 'package:coffeecard/model/login.dart';
import 'package:coffeecard/model/token.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  static const String PRODUCTION_URL = "https://analogio.dk/clippy";
  static const String DEBUG_URL = "https://beta.analogio.dk/api/clippy";

  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("​/api​/v1​/AppConfig")
  Future<AppConfig> getAppConfig();

  @POST("/api/v1/Account/login")
  Future<Token> login(@Body() Login login);
}