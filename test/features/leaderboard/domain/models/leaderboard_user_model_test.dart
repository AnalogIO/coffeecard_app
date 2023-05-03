import 'package:coffeecard/features/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should map LeaderboardEntry', () {
    // arrange
    final entry = LeaderboardEntry(
      id: 0,
      rank: 0,
      score: 0,
      name: 'name',
    );

    // act
    final actual = LeaderboardUserModel.fromDTO(entry);

    // assert
    expect(
      actual,
      const LeaderboardUserModel(
        id: 0,
        rank: 0,
        score: 0,
        name: 'name',
        highlight: false,
      ),
    );
  });
}
