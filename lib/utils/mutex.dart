import 'dart:async';
import 'dart:collection';

import 'package:fpdart/fpdart.dart';

class Mutex {
  final _waitQueue = Queue<Completer<void>>();
  bool _isLocked = false;

  Task<Unit> _dequeue() {
    _waitQueue.removeFirst().complete();
    return Task.of(unit);
  }

  Task<Unit> _setLocked(bool value) {
    _isLocked = value;
    return Task.of(unit);
  }

  /// Indicates whether the lock is currently acquired.
  bool get isLocked => _isLocked;

  /// Acquires the lock, runs the provided action, and then releases the lock.
  ///
  /// If the lock is already acquired, this method will wait until the lock is
  /// released before acquiring it and running the action.
  Task<T> protect<T>(Task<T> criticalSection) {
    // return Task(() async {
    //   await _lock().run();
    //   final result = await criticalSection.run();
    //   await _unlock().run();
    //   return result;
    // });
    return _lock().call(criticalSection).chainFirst((_) => _unlock());
  }

  // /// Waits until the lock is released, then runs the given action (without
  // /// acquiring the lock).
  // ///
  // /// If the lock is not currently acquired, the action will be run immediately.
  // Task<T> runWithoutLock<T>(Task<T> action) {
  //   return _waitUntilUnlocked().call(action);
  // }

  /// Waits until the lock is released.
  Task<Unit> _waitInQueue() {
    return _isLocked.match(
      () => Task.of(unit),
      () => Task(() async {
        final completer = Completer<void>();
        _waitQueue.add(completer);
        await completer.future;
        return unit;
      }),
    );
  }

  /// Acquires the lock.
  ///
  /// If the lock is already acquired, the task will wait in the wait queue
  /// until it is woke up by the previous task releasing the lock.
  Task<Unit> _lock() {
    return _isLocked.match(
      () => _setLocked(true),
      () => _waitInQueue(),
    );
  }

  /// Releases the lock.
  ///
  /// If the wait queue is not empty, wakes up the next task in the queue.
  /// Otherwise, sets the lock to unlocked.
  Task<Unit> _unlock() {
    return _waitQueue.isNotEmpty.match(
      () => _setLocked(false),
      () => _dequeue(),
    );
  }
}

extension TaskMutexX<T> on Task<T> {
  /// Runs the task in a critical section protected by the given [mutex].
  ///
  /// If the mutex is already locked, this method will wait until the mutex is
  /// released before acquiring it and running the task.
  Task<T> protectWith(Mutex mutex) => mutex.protect(this);
}
