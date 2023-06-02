// import 'dart:async';

// import 'package:coffeecard/utils/mutex.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   late Mutex mutex;

//   setUp(() {
//     mutex = Mutex();

//     expect(
//       mutex.isLocked,
//       isFalse,
//       reason: 'Mutex should be initially unlocked',
//     );
//   });

//   tearDown(() async {
//     // Allow the event loop to run to completion.
//     await Future.delayed(Duration.zero);

//     expect(
//       mutex.isLocked,
//       isFalse,
//       reason: 'Mutex should be unlocked after test',
//     );
//   });

//   test(
//     'GIVEN an unlocked mutex '
//     'WHEN protect is called '
//     'THEN it should lock before running the action and unlock after',
//     () async {
//       final result = await mutex.protect(() async {
//         expect(mutex.isLocked, isTrue);
//         return 42;
//       });

//       expect(result, 42);
//     },
//   );

//   test(
//     'GIVEN a mutex locked by one task '
//     'WHEN another task tries to lock it '
//     'THEN it should wait until the first task completes '
//     'and the mutex is unlocked',
//     () async {
//       final firstTaskCompleter = Completer<void>();
//       final secondTaskCompleter = Completer<void>();

//       Future<void> firstTask() async {
//         await mutex.protect(() async => firstTaskCompleter.future);
//       }

//       Future<void> secondTask() async {
//         await mutex.protect(() => secondTaskCompleter.complete());
//       }

//       // Start the first task, which will hold the lock until firstTaskCompleter
//       // completes.
//       firstTask();

//       // Allow the first task to acquire the lock
//       // and then start the second task.
//       expect(mutex.isLocked, isTrue);
//       secondTask();

//       // The second task shouldn't complete until we complete the first task.
//       expect(secondTaskCompleter.isCompleted, isFalse);

//       // Complete the first task, which should release the lock and allow the
//       // second task to complete.
//       firstTaskCompleter.complete();

//       // Wait for the second task to complete.
//       await secondTaskCompleter.future;
//     },
//   );

//   test(
//     'GIVEN an unlocked mutex '
//     'WHEN waitAndRun is called '
//     'THEN it should not acquire the lock and should run the action immediately',
//     () async {
//       final result = await mutex.runWhenUnlocked(() async {
//         expect(mutex.isLocked, isFalse);
//         return 42;
//       });

//       expect(result, 42);
//     },
//   );

//   test(
//     'GIVEN a mutex locked by one task '
//     'WHEN another task calls waitAndRun '
//     'THEN it should wait until the lock is released, '
//     'then run the action without acquiring the lock',
//     () async {
//       final firstTaskCompleter = Completer<void>();
//       final secondTaskCompleter = Completer<void>();

//       Future<void> firstTask() async {
//         await mutex.protect(() async => firstTaskCompleter.future);
//       }

//       Future<void> secondTask() async {
//         await mutex.runWhenUnlocked(() async {
//           // The lock should be released by the time we get here.
//           expect(mutex.isLocked, isFalse);
//           secondTaskCompleter.complete();
//         });
//       }

//       // Start the first task, which will hold the lock until firstTaskCompleter
//       // completes.
//       firstTask();

//       // Allow the first task to acquire the lock
//       // and then start the second task.
//       expect(mutex.isLocked, isTrue);
//       secondTask();

//       // The second task shouldn't complete until we complete the first task.
//       expect(secondTaskCompleter.isCompleted, isFalse);

//       // Complete the first task, which should release the lock and allow the
//       // second task to complete.
//       firstTaskCompleter.complete();
//     },
//   );
// }
