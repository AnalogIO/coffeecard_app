import 'dart:async';
import 'dart:collection';

import 'package:fpdart/fpdart.dart';

/// A mutual exclusion lock that can be used to protect critical sections of
/// code from concurrent access.
///
/// A [Mutex] can be acquired by calling the [protect] method with a [Task] that
/// represents the critical section of code to be protected. If the [Mutex] is
/// already locked, the [Task] will wait until the lock is released before
/// acquiring it and running the critical section.
///
/// Example usage:
///
/// ```dart
/// final mutex = Mutex();
/// final criticalSection = Task(() => 42).delay(Duration(seconds: 1));
///
/// // Both tasks will run sequentially.
/// final task1 = mutex.protect(criticalSection).run();
/// final task2 = mutex.protect(criticalSection).run();
///
/// print(await task1);
/// print(await task2);
/// // Output:
/// // 42
/// // 42
/// ```
class Mutex {
  final _waitQueue = Queue<Completer<void>>();
  bool _isLocked = false;

  /// Indicates whether the lock is currently acquired.
  bool get isLocked => _isLocked;

  /// Acquires the lock, runs the provided action, and then releases the lock.
  ///
  /// If the lock is already acquired, this method will wait until the lock is
  /// released before acquiring it and running the action.
  Task<T> protect<T>(Task<T> criticalSection) {
    return _lock().call(criticalSection).chainFirst((_) => _unlock());
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

  Task<Unit> _setLocked(bool value) {
    _isLocked = value;
    return Task.of(unit);
  }

  /// Adds a completer to the wait queue and waits for it to complete.
  Task<Unit> _waitInQueue() {
    return Task(() async {
      final completer = Completer<void>();
      _waitQueue.add(completer);
      await completer.future;
      return unit;
    });
  }

  /// Completes the first completer in the wait queue.
  Task<Unit> _dequeue() {
    _waitQueue.removeFirst().complete();
    return Task.of(unit);
  }
}

extension TaskMutexX<T> on Task<T> {
  /// Ensures the task will run in a critical section
  /// protected by the given [Mutex].
  ///
  /// If the mutex is already locked when the task is run, this method will wait
  /// until the mutex is released before acquiring it and running the task.
  Task<T> protect(Mutex mutex) => mutex.protect(this);
}
