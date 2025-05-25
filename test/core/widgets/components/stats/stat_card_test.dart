import 'package:coffeecard/features/leaderboard/presentation/widgets/statistics_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Statistics card has a title and rank', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatisticsCard(
            title: 'StatsTest',
            rank: 2,
            loading: false,
          ),
        ),
      ),
    );

    expect(find.text('StatsTest'), findsOneWidget);
    expect(find.text('2nd'), findsOneWidget);
  });

  testWidgets('Statistics card shows N/A if rank is 0', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatisticsCard(
            title: 'StatsTest',
            rank: 0,
            loading: false,
          ),
        ),
      ),
    );

    expect(find.text('StatsTest'), findsOneWidget);
    expect(find.textContaining('N/A'), findsOneWidget);
  });
}
