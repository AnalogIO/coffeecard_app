import 'package:coffeecard/model/account/email.dart';
import 'package:coffeecard/model/account/user_id.dart';
import 'package:coffeecard/model/app_config.dart';
import 'package:coffeecard/model/account/login.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/model/account/register_user.dart';
import 'package:coffeecard/model/account/token.dart';
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

  @POST("/api/v1/Account/register")
  Future<void> register(@Body() RegisterUser register);

  @POST("/api/v1/Account/login")
  Future<Token> login(@Body() Login login);

  @GET("/api/v1/Account")
  Future<User> getUser();

  @POST("/api/v1/Account")
  Future<User> updateUser(@Body() User user);

  @GET("/api/v1/Account")
  Future<User> getUserById(@Body() UserId userId);

  @POST("/api/v1/Account/forgotpassword")
  Future<HttpResponse<String>> forgottenPassword(@Body() Email email);

}