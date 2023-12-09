import 'package:coffeecard/core/external/platform_service.dart';
import 'package:coffeecard/core/models/platform_type.dart';
import 'package:coffeecard/features/upgrader/data/datasources/app_store_api.dart';
import 'package:coffeecard/features/upgrader/data/datasources/play_store_api.dart';
import 'package:coffeecard/features/upgrader/domain/usecases/can_upgrade.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'can_upgrade_test.mocks.dart';

@GenerateMocks([AppStoreAPI, PlayStoreAPI, PlatformService])
void main() {
  late CanUpgrade usecase;
  late MockAppStoreAPI appStoreAPI;
  late MockPlayStoreAPI playStoreAPI;
  late MockPlatformService platformService;

  setUp(() {
    appStoreAPI = MockAppStoreAPI();
    playStoreAPI = MockPlayStoreAPI();
    platformService = MockPlatformService();
    usecase = CanUpgrade(
      appStoreAPI: appStoreAPI,
      playStoreAPI: playStoreAPI,
      platformService: platformService,
    );

    provideDummy<Option<String>>(none());
  });

  group('call', () {
    test('should return false if device is not Android or iOS', () async {
      // arrange
      when(platformService.currentVersion()).thenAnswer((_) async => 'version');
      when(platformService.platformType()).thenReturn(PlatformType.unknown);

      // act
      final actual = await usecase();

      // assert
      expect(actual, false);
    });

    test('should return true if device is Android and version mismatch',
        () async {
      // arrange
      when(platformService.currentVersion())
          .thenAnswer((_) async => 'device_version');
      when(platformService.platformType()).thenReturn(PlatformType.android);
      when(playStoreAPI.lookupVersion(any))
          .thenAnswer((_) async => some('external_version'));

      // act
      final actual = await usecase();

      // assert
      expect(actual, true);
    });

    test('should return false if device is Android and version match',
        () async {
      // arrange
      const version = 'device_version';

      when(platformService.currentVersion()).thenAnswer((_) async => version);
      when(platformService.platformType()).thenReturn(PlatformType.android);

      when(playStoreAPI.lookupVersion(any))
          .thenAnswer((_) async => some(version));

      // act
      final actual = await usecase();

      // assert
      expect(actual, false);
    });

    test('should return true if device is iOS and version mismatch', () async {
      // arrange
      when(platformService.currentVersion())
          .thenAnswer((_) async => 'device_version');
      when(platformService.platformType()).thenReturn(PlatformType.iOS);

      when(appStoreAPI.lookupVersion(any))
          .thenAnswer((_) async => some('external_version'));

      // act
      final actual = await usecase();

      // assert
      expect(actual, true);
    });

    test('should return false if device is iOS and version match', () async {
      // arrange
      const version = 'device_version';

      when(platformService.currentVersion()).thenAnswer((_) async => version);
      when(platformService.platformType()).thenReturn(PlatformType.iOS);

      when(appStoreAPI.lookupVersion(any))
          .thenAnswer((_) async => some(version));

      // act
      final actual = await usecase();

      // assert
      expect(actual, false);
    });
  });
}
