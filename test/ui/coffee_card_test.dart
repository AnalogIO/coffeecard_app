import 'package:coffeecard/widgets/components/tickets/coffee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CoffeeCard has a title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoffeeCard(
            title: 'Coffee',
            amountOwned: 0,
            productId: 0,
          ),
        ),
      ),
    );
    expect(find.text('Coffee'), findsOneWidget);
  });

  testWidgets('Coffee card matches golden file', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoffeeCard(
            title: 'Coffee',
            amountOwned: 1,
            productId: 0,
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(CoffeeCard),
      matchesGoldenFile('goldens/coffee_card.png'),
    );
  });
}
