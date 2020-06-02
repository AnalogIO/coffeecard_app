// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffeecard/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our app bar title reads 'Tickets'.
    expect(find.text('Tickets'), findsWidgets);
    expect(find.text('Receipts'), findsOneWidget);

    // Tap the Receipts icon in the navigation bar and trigger a frame.
    await tester.tap(find.byIcon(Icons.receipt));
    await tester.pump();

    // Verify that we have changed pages.
    expect(find.text('Tickets'), findsOneWidget);
    expect(find.text('Receipts'), findsWidgets);
  });
}
