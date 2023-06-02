import 'package:fpdart/fpdart.dart';

/// Utility class to combine multiple invocations of some [Task]s into one
/// if subsequent invocations happen before the first invocation has completed.
class Throttler<T> {
  /// Creates a new [Throttler] with the given [task].
  Throttler();

  Task<T> _storeTask(Task<T> task) {
    _throttledTask = some(task);
    return task;
  }

  Task<Unit> get _clearTask {
    _throttledTask = none();
    return Task.of(unit);
  }

  /// Stores the currently running task, if any.
  late Option<Task<T>> _throttledTask = none();

  /// If no task is currently running, starts the given [task] and stores it.
  /// Otherwise, returns the currently running task.
  Task<T> throttle(Task<T> task) {
    return _throttledTask.getOrElse(
      () => _storeTask(task).chainFirst((_) => _clearTask),
    );
  }
}

extension ThrottlerX<T> on Task<T> {
  /// Throttles this task using the given [throttler].
  ///
  /// If no task is currently running through the [throttler], starts this task
  /// and stores it. Otherwise, returns the currently running task.
  Task<T> throttleWith(Throttler<T> throttler) => throttler.throttle(this);
}
