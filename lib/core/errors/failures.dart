import 'dart:convert';

import 'package:chopper/chopper.dart';
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

  factory ServerFailure.fromResponse(Response response) {
    try {
      final jsonString =
          json.decode(response.bodyString) as Map<String, dynamic>;
      final message = jsonString['message'] as String?;
      return ServerFailure(message ?? 'Unknown error occurred');
    } on FormatException {
      return const ServerFailure('Unknown error occurred');
    }
  }
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure(super.reason);
}
