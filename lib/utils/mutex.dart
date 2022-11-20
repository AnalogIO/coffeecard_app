import 'dart:async';

class Mutex {
  Future<void>? _lock;
  final _completer = Completer();

  bool isLocked() => _lock != null;

  void lock() {
    _lock = _completer.future;
  }

  void unlock() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }

    _lock = null;
  }

  Future<void> wait() async {
    await _lock;
  }
}
