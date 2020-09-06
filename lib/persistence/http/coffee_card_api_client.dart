import 'package:coffeecard/model/account/email.dart';
import 'package:coffeecard/model/account/user_id.dart';
import 'package:coffeecard/model/app_config.dart';
import 'package:coffeecard/model/account/login.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/model/account/register_user.dart';
import 'package:coffeecard/model/account/token.dart';
import 'package:coffeecard/model/products/product.dart';
import 'package:coffeecard/model/tickets/coffee_card.dart';
import 'package:coffeecard/model/tickets/ticket.dart';
import 'package:coffeecard/model/tickets/use_ticket_for_product.dart';
import 'package:coffeecard/model/tickets/use_tickets_for_multiple_products.dart';
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
  Future<void> register(@Body() RegisterUser register); //TODO fix the return type

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

  @GET("/api/v1/Tickets")
  // ignore: avoid_positional_boolean_parameters
  Future<List<Ticket>> getTickets(@Body() bool isUsed);

  @GET("/api/v1/CoffeeCards")
  Future<List<CoffeeCard>> getUsersCoffeeCards();

  @POST("/api/v1/Tickets/use")
  Future<Ticket> useTicket(@Body() UseTicketForProduct ticket);

  @POST("/api/v1/Tickets/use")
  Future<List<Ticket>> useMultipleTickets(@Body() UseTicketsForMultipleProducts tickets);

  @GET("/api/v1/Products")
  Future<List<Product>> getProducts();
}