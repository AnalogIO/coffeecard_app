import 'dart:async';

import 'package:coffeecard/utils/throttler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('Throttler', () {
    late int counter;
    late Completer<void> taskCompleter;

    final throttler = Throttler<Unit>();
    final incrementTask = Task(() async {
      print('incrementTask');
      return ++counter;
    }).map((_) => unit);

    Task<Unit> incrementAndWaitTask(Completer<void> completer) {
      return Task(() async {
        ++counter;
        return completer.future;
      }).map((a) => unit);
    }

    setUp(() {
      counter = 0;
      taskCompleter = Completer<void>();
    });

    test(
      'GIVEN a Throttler with no previous calls '
      'WHEN a task is throttled '
      'THEN it should execute the task',
      () async {
        await incrementTask.throttleWith(throttler).run();
        expect(counter, 1);
      },
    );

    test(
      'GIVEN a Throttler with a previous call '
      'WHEN a task is throttled '
      'THEN it should not execute the task',
      () async {
        // Throttle a task that will increment the counter, but not complete
        // until the taskCompleter is completed.
        final task1 =
            incrementAndWaitTask(taskCompleter).throttleWith(throttler).run();

        // Throttle a task that will increment the counter.
        final task2 = incrementTask.throttleWith(throttler).run();

        // Allow the tasks to complete.
        taskCompleter.complete();
        await task1;
        await task2;

        expect(counter, 1);
      },
    );
  });
}
