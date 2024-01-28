import 'package:coffeecard/core/widgets/components/tickets_card.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testProduct = const Product.empty().copyWith(name: 'Small drink');
  final testTicket = const Ticket.empty().copyWith(product: testProduct);

  testWidgets('TicketsCard has a title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TicketsCard(testTicket))),
    );
    expect(find.text('Small drink'), findsOneWidget);
  });

  // TODO(marfavi): Due to the use of OS-specific rendering of golden files,
  //  this test will fail on Windows and Mac. We should find a way to make
  //  golden tests platform-independent.
  testWidgets(
    'Tickets card matches golden file',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TicketsCard(testTicket))),
      );
      await expectLater(
        find.byType(TicketsCard),
        matchesGoldenFile('goldens/tickets_card.png'),
      );
    },
    skip: true,
  );
}
