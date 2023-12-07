import 'package:coffeecard/features/upgrader/data/datasources/upgrader_remote_data_source.dart';
import 'package:coffeecard/features/upgrader/data/models/update_status.dart';
import 'package:coffeecard/features/upgrader/domain/usecases/can_upgrade.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'can_upgrade_test.mocks.dart';

@GenerateMocks([UpgraderRemoteDataSource])
void main() {
  late CanUpgrade usecase;
  late MockUpgraderRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockUpgraderRemoteDataSource();
    usecase = CanUpgrade(
      remoteDataSource: remoteDataSource,
    );
  });

  group('call', () {
    test('should return false if update available is unknown', () async {
      // arrange
      when(remoteDataSource.isUpdateAvailable())
          .thenAnswer((_) async => UpdateStatus.unknown);

      // act
      final actual = await usecase();

      // assert
      expect(actual, false);
    });

    test('should return true if new version is available', () async {
      // arrange
      when(remoteDataSource.isUpdateAvailable())
          .thenAnswer((_) async => UpdateStatus.newVersionAvailable);

      // act
      final actual = await usecase();

      // assert
      expect(actual, true);
    });

    test('should return false if app is up to date', () async {
      // arrange
      when(remoteDataSource.isUpdateAvailable())
          .thenAnswer((_) async => UpdateStatus.upToDate);

      // act
      final actual = await usecase();

      // assert
      expect(actual, false);
    });
  });
}
