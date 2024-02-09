import 'package:fpdart/fpdart.dart';

extension TaskX<A> on Task<A> {
  /// Ensure that this task takes at least [duration] to complete.
  ///
  /// If the task completes before [duration], the returned task will
  /// wait for the remaining time before returning the result.
  Task<A> withMinimumDuration(Duration duration) => Task(() async {
        final minimumDurationTask = Future.delayed(duration);
        final result = await run();
        await minimumDurationTask;
        return result;
      });
}
