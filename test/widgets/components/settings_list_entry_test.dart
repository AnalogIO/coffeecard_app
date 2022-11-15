import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:coffeecard/widgets/pages/settings/setting_value_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SettingListEntry should match golden file', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SettingListEntry(
            name: 'email',
            valueWidget: SettingValueText(
              value:
                  'This is a very long text that should be truncated, This is a very long text that should be truncated, This is a very long text that should be truncated',
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(SettingListEntry),
      matchesGoldenFile('goldens/setting_list_entry.png'),
    );
  });
}
