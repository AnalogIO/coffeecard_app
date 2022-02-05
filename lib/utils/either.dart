abstract class Either<L, R> {
  const Either();

  bool get success => this is Right<L, R>;
  bool get failure => this is Left<L, R>;

  L get left => (this as Left<L, R>)._l;
  R get right => (this as Right<L, R>)._r;
}

class Left<L, R> extends Either<L, R> {
  final L _l;

  const Left(this._l);
}

class Right<L, R> extends Either<L, R> {
  final R _r;

  const Right(this._r);
}
