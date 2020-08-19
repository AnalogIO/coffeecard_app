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
  testWidgets('Change pages from navbar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that our app reads 'Tickets' at least once
    // (once in the app bar and once in the navigation bar).
    // All other page titles should only read once (in the navigation bar).
    // (We ignore the 'Statistics' page here, as its nav bar title is shortened)
    expect(find.text('Tickets'), findsWidgets);
    expect(find.text('Receipts'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Tap the Receipts icon in the navigation bar and trigger a frame.
    await tester.tap(find.byIcon(Icons.receipt));
    await tester.pump();

    // Verify that we have changed pages.
    expect(find.text('Tickets'), findsOneWidget);
    expect(find.text('Receipts'), findsWidgets);
    expect(find.text('Settings'), findsOneWidget);
  });
}
