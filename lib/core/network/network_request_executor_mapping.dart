part of 'network_request_executor.dart';

extension ExecutorMapX<R> on _ExecutorResult<R> {
  /// If the result of the [Future] is a [Right], maps the value to a [C].
  _ExecutorResult<C> map<C>(C Function(R) mapper) async {
    final result = await this;
    return result.map(mapper);
  }
}

extension ExecutorMapAllX<R> on _ExecutorResult<Iterable<R>> {
  /// If the result of the [Future] is a [Right],
  /// maps all values to a [List] of [C].
  // TODO(marfavi): return Iterable instead of List?
  _ExecutorResult<List<C>> mapAll<C>(C Function(R) mapper) async {
    final result = await this;
    return result.map((items) => items.map(mapper).toList());
  }
}
