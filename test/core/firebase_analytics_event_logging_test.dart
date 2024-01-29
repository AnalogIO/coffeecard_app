import 'package:coffeecard/core/firebase_analytics_event_logging.dart';
import 'package:coffeecard/features/product/menu_item_model.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_analytics_event_logging_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseAnalytics>()])
void main() {
  late FirebaseAnalyticsEventLogging eventLogging;
  late MockFirebaseAnalytics mockAnalytics;

  const amount = 10;
  const price = 10;
  const currency = 'DKK';

  Product productWithId(int id) {
    return Product(
      id: id,
      name: 'Product $id',
      price: price,
      amount: amount,
      description: '',
      isPerk: false,
      eligibleMenuItems: const [MenuItem(id: 0, name: 'Cappuccino')],
    );
  }

  Payment paymentWithProductId(int id) {
    return Payment(
      id: id,
      productId: 0,
      productName: 'Product 0',
      price: price,
      deeplink: '',
      purchaseTime: DateTime.now(),
      status: PaymentStatus.awaitingPayment,
    );
  }

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    eventLogging = FirebaseAnalyticsEventLogging(mockAnalytics);
  });

  group('FirebaseAnalyticsEventLogging', () {
    test(
      'errorEvent should log application_error event with the given error',
      () {
        const error = 'Test error';
        eventLogging.errorEvent(error);

        verify(
          mockAnalytics.logEvent(
            name: 'application_error',
            parameters: {'reason': error},
          ),
        ).called(1);
      },
    );

    test(
      'selectProductFromListEvent should log SelectItem event with the given parameters',
      () {
        const listId = '12345';
        const listName = 'Test List';
        final product = productWithId(1);

        eventLogging.selectProductFromListEvent(product, listId, listName);

        verify(
          mockAnalytics.logSelectItem(
            itemListId: listId,
            itemListName: listName,
            items: anyNamed('items'),
          ),
        ).called(1);
      },
    );

    test(
      'viewProductsListEvent should log ViewItemList event with the given parameters',
      () {
        final products = [productWithId(1), productWithId(2)];
        const listId = '12345';
        const listName = 'Test List';

        eventLogging.viewProductsListEvent(products, listId, listName);

        verify(
          mockAnalytics.logViewItemList(
            itemListId: listId,
            itemListName: listName,
            items: anyNamed('items'),
          ),
        ).called(1);
      },
    );

    test(
      'viewProductEvent should log ViewItem event with the given product',
      () {
        final product = productWithId(1);

        eventLogging.viewProductEvent(product);

        verify(
          mockAnalytics.logViewItem(
            currency: currency,
            value: price.toDouble(),
            items: anyNamed('items'),
          ),
        ).called(1);
      },
    );

    test(
      'beginCheckoutEvent should log BeginCheckout event with the given product',
      () {
        final product = productWithId(1);

        eventLogging.beginCheckoutEvent(product);

        verify(
          mockAnalytics.logBeginCheckout(
            currency: currency,
            value: price.toDouble(),
            items: anyNamed('items'),
          ),
        ).called(1);
      },
    );

    test(
      'purchaseCompletedEvent should log Purchase event with the given payment',
      () {
        final payment = paymentWithProductId(1);

        eventLogging.purchaseCompletedEvent(payment);

        verify(
          mockAnalytics.logPurchase(
            currency: currency,
            value: price.toDouble(),
            transactionId: payment.id.toString(),
            items: anyNamed('items'),
          ),
        ).called(1);
      },
    );

    test(
      'loginEvent should log Login event with the specified login method',
      () {
        eventLogging.loginEvent();

        verify(
          mockAnalytics.logLogin(loginMethod: 'UsernamePassword'),
        ).called(1);
      },
    );

    test(
      'signUpEvent should log SignUp event with the specified login method',
      () {
        eventLogging.signUpEvent();

        verify(
          mockAnalytics.logSignUp(signUpMethod: 'UsernamePassword'),
        ).called(1);
      },
    );
  });
}
