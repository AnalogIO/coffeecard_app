import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String reason;

  const Failure(this.reason);

  @override
  List<Object?> get props => [reason];
}

abstract class NetworkFailure extends Failure {
  const NetworkFailure(super.reason);
}

class ServerFailure extends NetworkFailure {
  const ServerFailure(super.reason);

  factory ServerFailure.fromResponse(Response response) {
    try {
      final jsonString =
          json.decode(response.bodyString) as Map<String, dynamic>;

      final message = jsonString['message'] as String?;

      if (message == null) {
        return const ServerFailure(Strings.unknownErrorOccured);
      }

      return ServerFailure(message);
    } on Exception {
      return const ServerFailure(Strings.unknownErrorOccured);
    }
  }
}

class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure() : super('connection refused');
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure(super.reason);
}
