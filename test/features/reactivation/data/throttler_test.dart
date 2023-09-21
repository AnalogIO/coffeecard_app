import 'dart:async';

import 'package:coffeecard/features/reactivation/data/throttler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  late int counter;
  late Completer<void> completer;

  final throttler = Throttler<int>();
  final incrementTask = Task(() async => counter = counter + 1);

  Task<int> incrementAndWaitTask(Completer<void> completer) {
    return Task(() async {
      await completer.future;
      return counter = counter + 1;
    });
  }

  setUp(() {
    counter = 0;
    completer = Completer<void>();
  });

  test(
    'GIVEN a Throttler with no previous calls '
    'WHEN a task is throttled '
    'THEN it should execute the task',
    () async {
      await incrementTask.runThrottled(throttler);
      expect(counter, 1);
    },
  );

  test(
    'GIVEN a throttler with no previous calls '
    'WHEN a task is throttled twice in parallel '
    'THEN the futures returned by runThrottled should be identical',
    () async {
      // Throttle a task that will wait for the completer to complete,
      // and then increment the counter.
      final task1 = incrementAndWaitTask(completer).runThrottled(throttler);

      // Throttle a task that will increment the counter immediately.
      final task2 = incrementTask.runThrottled(throttler);

      // Since task2 was run while task1 was still running,
      // their futures should be identical.
      expect(task1, same(task2));

      // Allow the task to complete.
      completer.complete();
    },
  );

  test(
    'GIVEN a Throttler with an ongoing running task '
    'WHEN an additional two tasks are throttled '
    'THEN it should execute only the first task',
    () async {
      // Throttle a task that will wait for the completer to complete,
      // and then increment the counter.
      final task1 = incrementAndWaitTask(completer).runThrottled(throttler);

      // Throttle another task that will increment the counter immediately.
      final task2 = incrementTask.runThrottled(throttler);

      // Throttle one more task that will increment the counter immediately.
      final task3 = incrementTask.runThrottled(throttler);

      // Since task2 and task3 were run while task1 was still running,
      // all futures should be identical.
      expect([task1, task2, task3], everyElement(same(task1)));

      // Allow the tasks to complete.
      completer.complete();
      await task1;
      await task2;
      await task3;

      expect(counter, 1);
    },
  );

  test(
    'GIVEN a Throttler with no pending tasks '
    'WHEN a task is throttled after the previous task is completed '
    'THEN it should execute the task',
    () async {
      // Throttle a task and wait for completion.
      await incrementTask.runThrottled(throttler);

      // Throttle another task and wait for completion.
      await incrementTask.runThrottled(throttler);

      // The counter should have incremented twice.
      expect(counter, 2);
    },
  );
}
