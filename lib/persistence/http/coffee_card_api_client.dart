import 'package:coffeecard/model/app_config.dart';
import 'package:coffeecard/model/login.dart';
import 'package:coffeecard/model/token.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'coffee_card_api_client.g.dart';

@RestApi()
abstract class CoffeeCardApiClient {
  static const String productionUrl = "https://analogio.dk/clippy";
  static const String testUrl = "https://beta.analogio.dk/api/clippy";

  factory CoffeeCardApiClient(Dio dio, {String baseUrl}) = _CoffeeCardApiClient;

  @GET("​/api​/v1​/AppConfig")
  Future<AppConfig> getAppConfig();

  @POST("/api/v1/Account/login")
  Future<Token> login(@Body() Login login);
}