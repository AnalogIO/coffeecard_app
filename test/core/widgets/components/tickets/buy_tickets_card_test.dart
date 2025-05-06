import 'package:coffeecard/features/product/presentation/widgets/buy_tickets_card.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BuyTicketsCard should have product information', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BuyTicketsCard(
            Product(
              id: 0,
              name: 'CoffeeTitle',
              description: 'CoffeeDescription',
              amount: 2,
              price: 10,
              isPerk: false,
              eligibleMenuItems: [],
            ),
          ),
        ),
      ),
    );

    expect(find.text('CoffeeTitle'), findsOneWidget);
    expect(find.text('CoffeeDescription'), findsOneWidget);
    expect(find.text('2 tickets'), findsOneWidget);
    expect(find.text('10,-'), findsOneWidget);
  });
}
