import 'dart:async';

// https://gist.github.com/venkatd/7125882a8e86d80000ea4c2da2c2a8ad
/// Debouncer starts a timer when called.
/// If called again before the timer finishes, the timer is reset.
/// If the timer finishes, the callback function is invoked.
///
/// Usage:
/// ```dart
/// // Initialize the debouncer
/// final _debounce = Debouncer(duration);
///
/// // ... and then call it
/// void onChanged() {
///   _debounce(() => validate(text));
/// }
/// ```
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer = null;
  }
}
