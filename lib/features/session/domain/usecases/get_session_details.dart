import 'package:coffeecard/features/session/data/datasources/session_local_data_source.dart';
import 'package:coffeecard/features/session/domain/entities/session_details.dart';
import 'package:fpdart/fpdart.dart';

class GetSessionDetails {
  final SessionLocalDataSource dataSource;

  GetSessionDetails({required this.dataSource});

  Future<Option<SessionDetails>> call() {
    return dataSource.getSessionDetails();
  }
}
