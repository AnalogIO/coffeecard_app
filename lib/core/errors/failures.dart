import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String reason;

  const Failure(this.reason);

  @override
  List<Object?> get props => [reason];
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure(super.reason);
}

sealed class NetworkFailure extends Failure {
  const NetworkFailure(super.reason);
}

class ServerFailure extends NetworkFailure {
  final int statuscode;

  const ServerFailure(super.reason, this.statuscode);

  factory ServerFailure.fromResponse(Response response) {
    try {
      final jsonString =
          json.decode(response.bodyString) as Map<String, dynamic>;

      final message = jsonString['message'] as String?;

      if (message == null) {
        return ServerFailure(
          Strings.unknownErrorOccured,
          response.statusCode,
        );
      }

      return ServerFailure(message, response.statusCode);
    } on Exception {
      return ServerFailure(
        Strings.unknownErrorOccured,
        response.statusCode,
      );
    }
  }
}

class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure() : super('connection refused');
}
