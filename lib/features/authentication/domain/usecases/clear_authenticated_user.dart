import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ClearAuthenticatedUser {
  final AuthenticationLocalDataSource dataSource;

  ClearAuthenticatedUser({required this.dataSource});

  Future<void> call() async {
    // Clear last used menu item
    final box = await Hive.openBox<int>('lastUsedMenuItemByProductId');
    await box.clear();

    await dataSource.clearAuthenticatedUser();
  }
}
