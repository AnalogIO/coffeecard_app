import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsEventLogging {
  final FirebaseAnalytics _firebaseAnalytics;

  static const String _currency = 'DKK';
  static const String _loginMethod = 'UsernamePassword';

  FirebaseAnalyticsEventLogging(this._firebaseAnalytics);

  void errorEvent(String error) {
    _firebaseAnalytics.logEvent(name: 'error', parameters: {'reason': error});
  }

  void selectProductFromListEvent(
    Product product,
    String listId,
    String listName,
  ) {
    _firebaseAnalytics.logSelectItem(
      itemListId: listId,
      itemListName: listName,
      items: [
        AnalyticsEventItem(
          itemId: product.id.toString(),
          itemName: product.name,
          price: product.price,
          currency: _currency,
        )
      ],
    );
  }

  void viewProductsListEvent(
    List<Product> products,
    String listId,
    String listName,
  ) {
    _firebaseAnalytics.logViewItemList(
      itemListId: listId,
      itemListName: listName,
      items: products
          .map(
            (p) => AnalyticsEventItem(
              itemId: p.id.toString(),
              itemName: p.name,
              price: p.price,
              currency: _currency,
            ),
          )
          .toList(),
    );
  }

  void viewProductEvent(
    Product product,
    String listId,
    String listName,
  ) {
    _firebaseAnalytics.logViewItem(
      currency: _currency,
      value: product.price.toDouble(),
      items: [
        AnalyticsEventItem(
          itemId: product.id.toString(),
          itemName: product.name,
          price: product.price,
          currency: _currency,
        )
      ],
    );
  }

  void beginCheckoutEvent(Product product) {
    _firebaseAnalytics.logBeginCheckout(
      value: product.price.toDouble(),
      currency: _currency,
      items: [
        AnalyticsEventItem(
          itemId: product.id.toString(),
          itemName: product.name,
          price: product.price.toDouble(),
          currency: _currency,
        )
      ],
    );
  }

  void purchaseCompletedEvent(Payment payment) {
    _firebaseAnalytics.logPurchase(
      currency: _currency,
      value: payment.price.toDouble(),
      items: [
        AnalyticsEventItem(
          itemId: payment.productId.toString(),
          itemName: payment.productName,
          price: payment.price.toDouble(),
          currency: _currency,
        )
      ],
      transactionId: payment.id.toString(),
    );
  }

  void loginEvent() {
    _firebaseAnalytics.logLogin(loginMethod: _loginMethod);
  }

  void signUpEvent() {
    _firebaseAnalytics.logSignUp(signUpMethod: _loginMethod);
  }
}
