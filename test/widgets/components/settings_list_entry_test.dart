import 'package:coffeecard/features/settings/presentation/widgets/setting_value_text.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'SettingsListEntry should match golden file with "normal" value',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingListEntry(
              name: 'email',
              valueWidget: SettingValueText(
                value: 'Normal email',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SettingListEntry), findsOneWidget);
      expect(find.text('Normal email'), findsOneWidget);

      await expectLater(
        find.byType(SettingListEntry),
        matchesGoldenFile('goldens/settings_list_entry_normal.png'),
      );
    },
  );
  testWidgets(
    'SettingListEntry when truncated should match golden file',
    (tester) async {
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
        matchesGoldenFile('goldens/setting_list_entry_truncated.png'),
      );
    },
  );
}
