part of 'database_connection_cubit.dart';

enum DatabaseConnectionStatus { unknown, test, production }

class DatabaseConnectionState extends Equatable {
  final DatabaseConnectionStatus status;

  //the widget should only be added once
  static bool widgetAdded = false;

  const DatabaseConnectionState({required this.status});

  @override
  List<Object> get props => [status, widgetAdded];

  @override
  String toString() {
    return 'database_connection_state {widgetAdded: $widgetAdded, status: $status}';
  }
}
