import 'dart:async';

/// A mutex that allows only one asynchronous operation to run at a time.
class Mutex {
  Completer<void> _lock = Completer<void>();

  /// Returns whether the lock is currently acquired.
  bool get isLocked => !_lock.isCompleted;

  /// Waits until the lock is released, then runs the given action (without
  /// acquiring the lock).
  ///
  /// If the lock is not currently acquired, the action will be run immediately.
  Future<T> runWithoutLock<T>(FutureOr<T> Function() action) async {
    if (isLocked) {
      await _lock.future;
    }
    return action();
  }

  /// Acquires the lock, runs the given action, and then releases the lock.
  ///
  /// If the lock is already acquired, this method will wait until the lock is
  /// released before acquiring it.
  Future<T> run<T>(FutureOr<T> Function() action) async {
    await _lock.future;
    try {
      return await action();
    } finally {
      if (_lock.isCompleted) {
        _lock = Completer<void>();
      }
    }
  }
}
