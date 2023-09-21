import 'package:fpdart/fpdart.dart';

/// A utility class for throttling the execution of asynchronous tasks.
///
/// This class allows you to limit the rate at which a task is executed by
/// ensuring that only one task runs through the [Throttler] at any given time.
/// If a task is already running, subsequent calls to execute a task will
/// instead return the currently running task.
///
/// To ensure type safety, the [Throttler] class is generic over the type of
/// the result of the task.
///
/// Example usage:
///
/// ```dart
/// Future<void> example() async {
///   int x = 0;
///   final throttler = Throttler<int>();
///   // Create a task that will increment the counter by 5 after 1 second.
///   final task = Task(() async => x += 5).delay(const Duration(seconds: 1));
///
///   // Run the task through the throttler twice.
///   final firstResult = throttler.throttle(task);
///   final secondResult = throttler.throttle(task);
///
///   // The two futures should be identical, since the second task was throttled
///   // while the first task was still running.
///   final isSame = identical(firstResult, secondResult);
///   print(isSame);
///   print(await firstResult);
///   print(await secondResult);
///
///   // Output:
///   // true
///   // 5
///   // 5
/// }
/// ```
class Throttler<T> {
  Throttler();

  Future<T>? _storedTask;

  /// If no task is currently running,
  /// runs the given [task] and stores it until it completes.
  /// Otherwise, returns the currently running task.
  Future<T> throttle(Task<T> task) {
    return Option.fromNullable(_storedTask).getOrElse(
      () => _storedTask = task.run().whenComplete(() => _storedTask = null),
    );
  }
}

extension ThrottlerX<T> on Task<T> {
  /// Throttles this task using the given [throttler].
  ///
  /// If no task is currently running through the [throttler], starts this task
  /// and stores it. Otherwise, returns the currently running task.
  Future<T> runThrottled(Throttler<T> throttler) => throttler.throttle(this);
}
