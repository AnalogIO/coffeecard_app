import 'package:coffeecard/env/env.dart';

class ApiUriConstants {
  static const String shiftyUrl = Env.shiftyUrl;

  static const String apiVersion = Env.apiVersion;

  static const String minAppVersion = Env.minAppVersion;

  static Uri analogIOGitHub = Uri.parse(Env.analogIOGitHub);

  // mobilepay urls
  static Uri mobilepayAndroid = Uri.parse(Env.mobilepayAndroid);
  static Uri mobilepayIOS = Uri.parse(Env.mobilepayIOS);

  static Uri privacyPolicyUri = Uri.parse(Env.privacyPolicyUri);

  static Uri feedbackFormUri = Uri.parse(Env.feedbackFormUri);

  static String getCoffeeCardUrl() {
    return Env.coffeeCardUrl;
  }
}
