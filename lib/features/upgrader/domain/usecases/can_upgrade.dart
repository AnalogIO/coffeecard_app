import 'package:coffeecard/core/api_uri_constants.dart';
import 'package:coffeecard/core/external/platform_service.dart';
import 'package:coffeecard/core/models/platform_type.dart';
import 'package:coffeecard/features/upgrader/data/datasources/app_store_api.dart';
import 'package:coffeecard/features/upgrader/data/datasources/play_store_api.dart';
import 'package:fpdart/fpdart.dart';

class CanUpgrade {
  final AppStoreAPI appStoreAPI;
  final PlayStoreAPI playStoreAPI;
  final PlatformService platformService;

  CanUpgrade({
    required this.appStoreAPI,
    required this.playStoreAPI,
    required this.platformService,
  });

  Future<bool> call() async {
    final currentVersion = await platformService.currentVersion();

    final version = switch (platformService.platformType()) {
      PlatformType.android =>
        await playStoreAPI.lookupVersion(ApiUriConstants.androidId),
      PlatformType.iOS =>
        await appStoreAPI.lookupVersion(ApiUriConstants.iOSBundle),
      PlatformType.unknown => none(),
    };

    return version.match(
      () => false,
      (version) => version != currentVersion,
    );
  }
}
