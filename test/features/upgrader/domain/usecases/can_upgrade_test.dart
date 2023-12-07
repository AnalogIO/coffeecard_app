import 'package:coffeecard/core/external/platform_service.dart';
import 'package:coffeecard/features/upgrader/data/datasources/app_store_api.dart';
import 'package:coffeecard/features/upgrader/data/datasources/play_store_api.dart';
import 'package:coffeecard/features/upgrader/domain/usecases/can_upgrade.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
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
  });

  group('call', () {
    test('should return none if device is not Android or iOS', () async {
      // arrange
      when(platformService.currentVersion()).thenAnswer((_) async => 'version');
      when(platformService.isAndroid()).thenReturn(false);
      when(platformService.isIOS()).thenReturn(false);

      // act
      final actual = await usecase();

      // assert
      expect(actual, none());
    });

    test('should return some(true) if device is Android and version mismatch',
        () async {
      // arrange
      when(platformService.currentVersion())
          .thenAnswer((_) async => 'device_version');
      when(platformService.isAndroid()).thenReturn(true);

      final document = Document();
      when(playStoreAPI.lookupById(any)).thenAnswer((_) async => document);
      when(playStoreAPI.version(document)).thenReturn('external_version');

      // act
      final actual = await usecase();

      // assert
      expect(actual, some(true));
    });

    test('should return some(false) if device is Android and version match',
        () async {
      // arrange
      const version = 'device_version';

      when(platformService.currentVersion()).thenAnswer((_) async => version);
      when(platformService.isAndroid()).thenReturn(true);

      final document = Document();
      when(playStoreAPI.lookupById(any)).thenAnswer((_) async => document);
      when(playStoreAPI.version(document)).thenReturn(version);

      // act
      final actual = await usecase();

      // assert
      expect(actual, some(false));
    });

    test('should return some(true) if device is iOS and version mismatch',
        () async {
      // arrange
      when(platformService.currentVersion())
          .thenAnswer((_) async => 'device_version');
      when(platformService.isAndroid()).thenReturn(false);
      when(platformService.isIOS()).thenReturn(true);

      when(appStoreAPI.lookupByBundleId(any)).thenAnswer((_) async => {});
      when(appStoreAPI.version(any)).thenReturn('external_version');

      // act
      final actual = await usecase();

      // assert
      expect(actual, some(true));
    });

    test('should return some(false) if device is iOS and version match',
        () async {
      // arrange
      const version = 'device_version';

      when(platformService.currentVersion()).thenAnswer((_) async => version);
      when(platformService.isAndroid()).thenReturn(false);
      when(platformService.isIOS()).thenReturn(true);

      when(appStoreAPI.lookupByBundleId(any)).thenAnswer((_) async => {});
      when(appStoreAPI.version(any)).thenReturn(version);

      // act
      final actual = await usecase();

      // assert
      expect(actual, some(false));
    });
  });
}
