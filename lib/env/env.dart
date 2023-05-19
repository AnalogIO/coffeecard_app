import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.develop')
abstract final class Env {
  @EnviedField(varName: 'coffeeCardUrl')
  static const coffeeCardUrl = _Env.coffeeCardUrl;
}
