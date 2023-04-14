import 'dart:async';

/// Utility class to filter subsequent calls to
/// a function within a given time period.
class Throttler {
  final Duration duration;
  DateTime? _lastRunAt;

  Throttler({required this.duration});

  bool get _shouldRun =>
      _lastRunAt == null || DateTime.now().difference(_lastRunAt!) > duration;

  /// Calls the given function if it the first call, or if the last call was
  /// longer ago than the given [duration].
  FutureOr<T> run<T>(FutureOr<T> Function() debounceFunction) {
    if (_shouldRun) {
      _lastRunAt = DateTime.now();
      return debounceFunction();
    }
    return Future.value();
  }
}
