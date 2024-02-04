part of 'store.dart';

/// A simple wrapper around [hive.Box] that provides a functional interface.
class Crate<ValueType> {
  const Crate(this._box);
  final hive.Box<ValueType> _box;

  Task<Unit> put(dynamic key, ValueType value) {
    return Task(() async {
      await _box.put(key, value);
      return unit;
    });
  }

  TaskOption<ValueType> get(dynamic key) {
    return TaskOption(() async => Option.fromNullable(_box.get(key)));
  }

  Task<Unit> clear() {
    return Task(() async {
      await _box.clear();
      return unit;
    });
  }
}
