import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

class PlatformService {
  bool isAndroid() => Platform.isAndroid;
  bool isIOS() => Platform.isIOS;
  Future<String> currentVersion() async =>
      PackageInfo.fromPlatform().then((info) => info.version);
}
