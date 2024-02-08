import 'package:coffeecard/features/session/data/datasources/session_local_data_source.dart';
import 'package:coffeecard/features/session/data/models/session_details_model.dart';
import 'package:fpdart/fpdart.dart';

class SaveSessionDetails {
  final SessionLocalDataSource dataSource;

  SaveSessionDetails({required this.dataSource});

  Future<void> call({
    required Option<Duration?> sessionTimeout,
    required Option<DateTime> lastLogin,
  }) async {
    return dataSource.saveSessionDetails(
      SessionDetailsModel(sessionTimeout: sessionTimeout, lastLogin: lastLogin),
    );
  }
}
