import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'coffeeCardUrl')
  static const coffeeCardUrl = _Env.coffeeCardUrl;
}
