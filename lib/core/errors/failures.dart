import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String reason;

  const Failure(this.reason);

  @override
  List<Object?> get props => [reason];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure(super.reason);
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure(super.reason);
}
