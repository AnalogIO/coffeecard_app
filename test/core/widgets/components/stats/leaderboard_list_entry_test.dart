import 'package:coffeecard/features/leaderboard/presentation/widgets/leaderboard_list_entry.dart';
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
}
