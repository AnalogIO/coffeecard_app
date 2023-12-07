import 'package:coffeecard/features/upgrader/data/models/update_status.dart';
import 'package:update_available/update_available.dart';

class UpgraderRemoteDataSource {
  Future<UpdateStatus> isUpdateAvailable() async {
    final updateAvailability = await getUpdateAvailability();

    return switch (updateAvailability) {
      UpdateAvailable() => UpdateStatus.newVersionAvailable,
      NoUpdateAvailable() => UpdateStatus.upToDate,
      UnknownAvailability() => UpdateStatus.unknown,
    };
  }
}
