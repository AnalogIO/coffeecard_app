import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/leaderboard/data/datasources/leaderboard_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'leaderboard_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late CoffeecardApiV2 apiV2;
  late NetworkRequestExecutor executor;
  late LeaderboardRemoteDataSource dataSource;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    dataSource = LeaderboardRemoteDataSource(apiV2: apiV2, executor: executor);
  });

  group('getLeaderboard', () {
    
  });

  group('getLeaderboardUser', () {});
}
