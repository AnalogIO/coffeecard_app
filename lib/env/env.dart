import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.develop')
abstract class Env {
  @EnviedField(varName: 'coffeeCardUrl')
  static final coffeeCardUrl = _Env.coffeeCardUrl;
}
