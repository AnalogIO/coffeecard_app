import 'dart:async';

import 'package:coffeecard/utils/mutex.dart';
import 'package:coffeecard/utils/throttler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  late Mutex mutex;

  setUp(() async {
    mutex = Mutex();

    expect(
      mutex.isLocked,
      isFalse,
      reason: 'Mutex should be initially unlocked',
    );
  });

  tearDown(() async {
    expect(
      mutex.isLocked,
      isFalse,
      reason: 'Mutex should be unlocked after test',
    );
  });

  test(
    'GIVEN an unlocked mutex and a false boolean '
    'WHEN protect is called with a task that changes the boolean to true '
    'THEN it the boolean should be true after the task completes',
    () async {
      var boolean = false;

      // Create a task that will change the boolean to true.
      final task = mutex.protect(
        Task(() async => boolean = true).map((_) => unit),
      );

      // Start and await the task, which should change the boolean to true.
      final _ = await task.run();

      // The boolean should be true now.
      expect(boolean, isTrue);
    },
  );

  test(
    'GIVEN an unlocked mutex and a false boolean '
    'WHEN protect is called with a task that returns the inverse of a bool '
    'THEN it should return true after the task completes',
    () {
      const boolean = false;

      // Create a task that will return the inverse of the boolean.
      final task = mutex.protect(
        Task(() async => !boolean),
      );

      // Start the task.
      final result = task.run();

      // The task should complete with true.
      expect(result, completion(isTrue));
    },
  );

  test(
    'GIVEN an unlocked mutex '
    'WHEN protect is called '
    'THEN it should lock after running the task',
    () {
      final completer = Completer<void>();

      // Create a task that will return with 42 when the completer is completed.
      final task = mutex.protect(
        Task(() => completer.future).map((_) => 42),
      );

      // Start the task, which should lock the mutex.
      final startedTask = task.run();

      // The mutex should be locked now.
      expect(
        mutex.isLocked,
        isTrue,
        reason: 'Mutex should be locked when task has started',
      );

      // Allow the task to complete.
      completer.complete();

      // The task should complete with 42.
      expect(startedTask, completion(42));
    },
  );

  test(
    'GIVEN a mutex locked by one task '
    'WHEN another task tries to lock it '
    'THEN it should wait until the first task completes '
    'and the mutex is unlocked',
    () {
      final firstTaskCompleter = Completer<void>();
      final secondTaskCompleter = Completer<void>();

      // Create a task that will finish executing
      // when firstTaskCompleter is completed.
      final firstTask = mutex.protect(
        Task(() => firstTaskCompleter.future).map((_) => unit),
      );

      // Create a task that will immediately complete secondTaskCompleter.
      final secondTask = mutex.protect(
        Task(() async => secondTaskCompleter.complete()).map((_) => unit),
      );

      // Start the first task, which will hold
      // the lock until firstTaskCompleter completes.
      final firstStartedTask = firstTask.run();

      // The mutex should be locked now.
      expect(
        mutex.isLocked,
        isTrue,
        reason: 'Mutex should be locked when task has started',
      );

      // Start the second task, which will wait until the lock is released.
      final secondStartedTask = secondTask.run();

      // The second task shouldn't complete until we complete the first task.
      expect(
        secondTaskCompleter.isCompleted,
        isFalse,
        reason: 'Second task completed before firstTaskCompleter was completed',
      );

      // Complete the first task, which should release the lock and allow the
      // second task to complete.
      firstTaskCompleter.complete();

      // The tasks should complete with unit.
      expect(firstStartedTask, completion(unit));
      expect(secondStartedTask, completion(unit));
    },
  );

  // test(
  //   'GIVEN a mutex locked by one task '
  //   'WHEN another task calls runWithoutLock '
  //   'THEN it should wait until the lock is released, '
  //   'then run the action without acquiring the lock',
  //   () async {
  //     final firstTaskCompleter = Completer<void>();
  //     final secondTaskCompleter = Completer<void>();

  //     final firstTask = mutex.protect(
  //       Task(() => firstTaskCompleter.future).map((_) => unit),
  //     );

  //     final secondTask = mutex.runWithoutLock(
  //       Task(() => secondTaskCompleter.future).map((_) => unit),
  //     );

  //     // Start the first task, which will hold
  //     // the lock until firstTaskCompleter completes.
  //     final firstStartedTask = firstTask.run();

  //     // First task should be holding the lock.
  //     expect(
  //       mutex.isLocked,
  //       isTrue,
  //       reason: 'Mutex should be locked when task has started',
  //     );

  //     // Start the second task, which will wait until the lock is released.
  //     secondTask.run();

  //     // The second task shouldn't complete until we complete the first task.
  //     expect(secondTaskCompleter.isCompleted, isFalse);

  //     // Complete the first task, which should release the lock and allow the
  //     // second task to run.
  //     firstTaskCompleter.complete();
  //     // Await the first task to ensure that it has released the lock.
  //     await firstStartedTask;

  //     // The second task should be running, but not holding the lock.
  //     expect(
  //       mutex.isLocked,
  //       isFalse,
  //       reason: 'Mutex should be unlocked when second task has started',
  //     );

  //     // Allow the second task to complete.
  //     secondTaskCompleter.complete();

  //     // Both tasks should complete with unit.
  //     expect(firstTask, completion(unit));
  //     expect(secondTask, completion(unit));
  //   },
  // );
}
