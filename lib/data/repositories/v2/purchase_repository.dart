import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:logger/logger.dart';

class PurchaseRepository {
  final CoffeecardApiV2 _api;
  final Logger _logger;

  PurchaseRepository(this._api, this._logger);

  /// Initiate a new Purchase Request. The return is a purchase request
  /// with payment details on how to pay for the purchase
  Future<InitiatePurchaseResponse> initiatePurchase(
    int productId,
    PaymentType paymentType,
  ) async {
    final response = await _api.apiV2PurchasesPost(
      body: InitatePurchaseRequest(
        productId: productId,
        paymentType: paymentType,
      ),
    );

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }

  /// Get all user's purchases
  Future<List<Purchase>> getAllPurchases() async {
    final response = await _api.apiV2PurchasesGet();

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }

  /// Get a purchase by its purchase id
  Future<Purchase> getPurchase(int purchaseId) async {
    final response = await _api.apiV2PurchasesPurchaseIdGet(
      purchaseId: purchaseId.toString(),
    );

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }
}
