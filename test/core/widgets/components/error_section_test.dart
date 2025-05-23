import 'package:coffeecard/core/widgets/components/error_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Error section has error message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorSection(
            error: 'Test error',
            retry: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining('Test error'), findsOneWidget);
  });
}
