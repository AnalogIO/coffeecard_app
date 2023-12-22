import 'dart:io';

import 'package:coffeecard/core/models/platform_type.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PlatformService {
  PlatformType platformType() {
    if (Platform.isAndroid) {
      return PlatformType.android;
    }

    if (Platform.isIOS) {
      return PlatformType.iOS;
    }

    return PlatformType.unknown;
  }

  Future<String> currentVersion() async =>
      PackageInfo.fromPlatform().then((info) => info.version);
}
