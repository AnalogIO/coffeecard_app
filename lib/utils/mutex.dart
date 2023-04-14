import 'dart:async';

class Mutex {
  Completer _lock = Completer<void>();

  /// Returns whether the lock is acquired.
  bool get isLocked => !_lock.isCompleted;

  /// Wait until the lock is released, then run the given action (without
  /// acquiring the lock).
  ///
  /// If the lock is not acquired, the action will be run immediately.
  Future<T> runWithoutLock<T>(FutureOr<T> Function() action) async {
    if (isLocked) {
      await _lock.future;
    }
    return action();
  }

  /// Acquires the lock, runs the given action, and then releases the lock.
  ///
  /// If the lock is already acquired, this call will wait until the lock is
  /// released.
  Future<T> run<T>(FutureOr<T> Function() action) async {
    await _acquire();
    try {
      return await action();
    } finally {
      _release();
    }
  }

  /// Acquires the lock.
  ///
  /// If the lock is already acquired, this call will wait until the lock is
  /// released.
  Future<void> _acquire() async {
    if (_lock.isCompleted) {
      _lock = Completer<void>();
    }
    await _lock.future;
  }

  /// Releases the lock.
  ///
  /// If the lock is not acquired, this call will throw an error.
  void _release() {
    if (!_lock.isCompleted) {
      throw StateError('Cannot release a lock that is not acquired.');
    }
    _lock.complete();
  }
}
