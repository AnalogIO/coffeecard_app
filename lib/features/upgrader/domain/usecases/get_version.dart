import 'package:coffeecard/core/external/platform_service.dart';
import 'package:coffeecard/features/upgrader/data/datasources/itunes_search_api.dart';
import 'package:coffeecard/features/upgrader/data/datasources/play_store_search_api.dart';
import 'package:fpdart/fpdart.dart';

class GetVersion {
  final ITunesSearchAPI appStoreAPI;
  final PlayStoreSearchAPI playStoreAPI;
  final PlatformService platformService;

  GetVersion({
    required this.appStoreAPI,
    required this.playStoreAPI,
    required this.platformService,
  });

  Future<Option<String>> call() async {
    if (platformService.isAndroid()) {
      return getAndroidVersion();
    }

    if (platformService.isIOS()) {
      return getiOSVersion();
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
