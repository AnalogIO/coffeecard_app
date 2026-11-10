import 'package:coffeecard/core/widgets/components/tickets_card.dart';
import 'package:coffeecard/core/widgets/design/analog_nav_bar.dart';
import 'package:coffeecard/core/widgets/design/glass_surface.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _items = [
  AnalogNavItem(
    icon: Icons.local_cafe_outlined,
    selectedIcon: Icons.local_cafe,
    label: 'Tickets',
  ),
  AnalogNavItem(
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    label: 'Receipts',
  ),
];

Widget _app(
  Widget child, {
  TargetPlatform platform = TargetPlatform.iOS,
  bool highContrast = false,
}) {
  return MaterialApp(
    theme: ThemeData(platform: platform),
    home: MediaQuery(
      data: MediaQueryData(highContrast: highContrast),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('GlassSurface', () {
    testWidgets('blurs the backdrop on iOS', (tester) async {
      await tester.pumpWidget(_app(const GlassSurface(child: Text('Glass'))));
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('is a solid tonal surface on Android', (tester) async {
      await tester.pumpWidget(
        _app(
          const GlassSurface(child: Text('Glass')),
          platform: TargetPlatform.android,
        ),
      );
      expect(find.byType(BackdropFilter), findsNothing);
      expect(find.text('Glass'), findsOneWidget);
    });

    testWidgets('drops the blur on iOS with increased contrast',
        (tester) async {
      await tester.pumpWidget(
        _app(const GlassSurface(child: Text('Glass')), highContrast: true),
      );
      expect(find.byType(BackdropFilter), findsNothing);
    });
  });

  group('AnalogNavBar', () {
    testWidgets('floats as a glass capsule on iOS', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        _app(
          AnalogNavBar(
            items: _items,
            currentIndex: 0,
            onTap: (i) => tapped = i,
          ),
        ),
      );
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(GlassSurface), findsOneWidget);

      await tester.tap(find.text('Receipts'));
      expect(tapped, 1);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Tickets')),
        matchesSemantics(
          label: 'Tickets',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
        ),
      );
    });

    testWidgets('uses a solid Material bar on Android', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        _app(
          AnalogNavBar(
            items: _items,
            currentIndex: 0,
            onTap: (i) => tapped = i,
          ),
          platform: TargetPlatform.android,
        ),
      );
      expect(find.byType(GlassSurface), findsNothing);
      await tester.tap(find.text('Receipts'));
      expect(tapped, 1);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Tickets')),
        matchesSemantics(
          label: 'Tickets',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
        ),
      );
    });
  });

  group('TicketsCard', () {
    final ticket = Ticket(
      product: const Product.empty().copyWith(name: 'Espresso based'),
      amountLeft: 7,
    );

    testWidgets('shows the product and remaining tickets', (tester) async {
      await tester.pumpWidget(
        _app(TicketsCard(ticket, tone: TicketTone.caramel)),
      );
      expect(find.text('Espresso based'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Espresso based, 7 tickets left'),
        findsOneWidget,
      );
      expect(find.byType(ClipPath), findsOneWidget);
    });

    testWidgets('fits a narrow screen with large text', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 640),
              textScaler: TextScaler.linear(1.6),
            ),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: TicketsCard(ticket),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    test('alternates tones', () {
      expect(TicketTone.forIndex(0), TicketTone.espresso);
      expect(TicketTone.forIndex(1), TicketTone.caramel);
      expect(TicketTone.forIndex(2), TicketTone.espresso);
    });
  });
}
