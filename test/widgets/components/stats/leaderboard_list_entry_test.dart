import 'package:coffeecard/features/statistics/presentation/widgets/leaderboard_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'LeaderboardListEntry given rank 0 should display rank as -',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeaderboardListEntry(
              id: 0,
              name: 'name',
              score: 0,
              rank: 0,
              highlight: false,
            ),
          ),
        ),
      );

      expect(find.byType(LeaderboardListEntry), findsOneWidget);
      expect(find.text('-'), findsOneWidget);
    },
  );
  testWidgets(
    'LeaderboardListEntry given rank 1 should display rank as 1',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeaderboardListEntry(
              id: 0,
              name: 'name',
              score: 0,
              rank: 1,
              highlight: false,
            ),
          ),
        ),
      );

      expect(find.byType(LeaderboardListEntry), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    },
  );
  testWidgets('LeaderboardListEntry should match golden file', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LeaderboardListEntry(
            id: 1,
            highlight: false,
            name: 'Test',
            rank: 1,
            score: 100,
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(LeaderboardListEntry),
      matchesGoldenFile('goldens/leaderboard_list_entry.png'),
    );
  });

  testWidgets(
    'LeaderboardListEntry when highlighted and truncated should match golden file',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeaderboardListEntry(
              id: 1,
              highlight: true,
              name:
                  'TestHighlighted with a very long name so it gets truncated and the score remains on the right',
              rank: 30,
              score: 1,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(LeaderboardListEntry),
        matchesGoldenFile('goldens/leaderboard_list_entry_highlighted.png'),
      );
    },
  );
}
