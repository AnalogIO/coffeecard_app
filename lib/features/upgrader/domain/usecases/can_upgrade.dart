import 'package:coffeecard/features/upgrader/data/datasources/upgrader_remote_data_source.dart';
import 'package:coffeecard/features/upgrader/data/models/update_status.dart';

class CanUpgrade {
  final UpgraderRemoteDataSource remoteDataSource;

  CanUpgrade({required this.remoteDataSource});

  Future<bool> call() async {
    final updateAvailable = await remoteDataSource.isUpdateAvailable();

    return switch (updateAvailable) {
      UpdateStatus.unknown => false,
      UpdateStatus.newVersionAvailable => true,
      UpdateStatus.upToDate => false,
    };
  }
}
