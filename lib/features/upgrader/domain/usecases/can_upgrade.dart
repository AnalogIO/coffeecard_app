import 'package:coffeecard/core/external/platform_service.dart';
import 'package:coffeecard/features/upgrader/data/datasources/itunes_search_api.dart';
import 'package:coffeecard/features/upgrader/data/datasources/play_store_search_api.dart';
import 'package:fpdart/fpdart.dart';

class CanUpgrade {
  final ITunesSearchAPI appStoreAPI;
  final PlayStoreSearchAPI playStoreAPI;
  final PlatformService platformService;

  CanUpgrade({
    required this.appStoreAPI,
    required this.playStoreAPI,
    required this.platformService,
  });

  Future<Option<bool>> call() async {
    final currentVersion = await platformService.currentVersion();

    if (platformService.isAndroid()) {
      final version = await getAndroidVersion();

      return version.map((version) => version != currentVersion);
    }

    if (platformService.isIOS()) {
      final version = await getiOSVersion();

      return version.map((version) => version != currentVersion);
    }

    return none();
  }

  Future<Option<String>> getiOSVersion() async {
    //FIXME: get id by other means
    final res = await playStoreAPI.lookupById('dk.analog.digitalclipcard');

    if (res == null) {
      return none();
    }

    final version = playStoreAPI.version(res);

    return Option.fromNullable(version);
  }

  Future<Option<String>> getAndroidVersion() async {
    //FIXME: get bundle id by other means
    final res =
        await appStoreAPI.lookupByBundleId('DK.AnalogIO.DigitalCoffeeCard');

    if (res == null) {
      return none();
    }

    final version = appStoreAPI.version(res);

    return Option.fromNullable(version);
  }
}