import 'package:coffeecard/core/widgets/design/glass_surface.dart';
import 'package:coffeecard/features/login/presentation/widgets/login_email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('email remains usable at narrow width with large text',
      (tester) async {
    String? submitted;
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
      child: Scaffold(
        body: Center(
            child: SizedBox(
                width: 264,
                child: LoginEmailTextField(
                    hasError: false,
                    autoFocusDelay: Duration.zero,
                    onSubmit: (_, value) => submitted = value,
                    onChange: () {}))),
      ),
    )));
    expect(tester.testTextInput.isVisible, isFalse);
    await tester.enterText(find.byType(TextField), ' hello@example.com ');
    await tester.tap(find.byType(IconButton));
    expect(submitted, 'hello@example.com');
    expect(tester.takeException(), isNull);
  });

  testWidgets('glass has an opaque fallback for increased contrast',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: MediaQuery(
      data: MediaQueryData(highContrast: true),
      child: GlassSurface(child: Text('Coffee')),
    )));
    final decorations =
        tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
    expect(
        decorations.any((box) =>
            box.decoration is BoxDecoration &&
            (box.decoration as BoxDecoration).color?.a == 1),
        isTrue);
    expect(find.text('Coffee'), findsOneWidget);
  });
}
