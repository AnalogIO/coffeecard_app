import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'apiVersion')
  static const apiVersion = _Env.apiVersion;
  @EnviedField(varName: 'productionUrl')
  static const productionUrl = _Env.productionUrl;
  @EnviedField(varName: 'testUrl')
  static const testUrl = _Env.testUrl;
  @EnviedField(varName: 'shiftyUrl')
  static const shiftyUrl = _Env.shiftyUrl;
  @EnviedField(varName: 'minAppVersion')
  static const minAppVersion = _Env.minAppVersion;
  @EnviedField(varName: 'analogIOGitHub')
  static const analogIOGitHub = _Env.analogIOGitHub;
  @EnviedField(varName: 'mobilepayAndroid')
  static const mobilepayAndroid = _Env.mobilepayAndroid;
  @EnviedField(varName: 'mobilepayIOS')
  static const mobilepayIOS = _Env.mobilepayIOS;
  @EnviedField(varName: 'privacyPolicyUri')
  static const privacyPolicyUri = _Env.privacyPolicyUri;
  @EnviedField(varName: 'feedbackFormUri')
  static const feedbackFormUri = _Env.feedbackFormUri;
  @EnviedField(varName: 'coffeeCardUrl')
  static const coffeeCardUrl = _Env.coffeeCardUrl;
}
