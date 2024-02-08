import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class SessionDetails extends Equatable {
  final Option<Duration?> sessionTimeout;
  final Option<DateTime> lastLogin;

  const SessionDetails({required this.sessionTimeout, required this.lastLogin});

  @override
  List<Object?> get props => [sessionTimeout, lastLogin];
}
