// Uri.parse does not return a const, so all globals can't be made const
// ignore_for_file: avoid-global-state
class ApiUriConstants {
  static Uri shiftyUrl = Uri.parse('https://analogio.dk/shiftplanning');
  static Uri analogIOGitHub = Uri.parse('https://github.com/AnalogIO/');

  static const String minAppVersion = '2.1.0';

  // Upgrader
  static const String androidId = 'dk.analog.digitalclipcard';
  static const String iOSBundle = 'DK.AnalogIO.DigitalCoffeeCard';

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$androidId';
  static const String appStoreUrl =
      'https://apps.apple.com/us/app/cafe-analog/id1148152818';

  // Mobilepay
  static Uri mobilepayAndroid =
      Uri.parse('market://details?id=dk.danskebank.mobilepay');
  static Uri mobilepayIOS =
      Uri.parse('itms-apps://itunes.apple.com/app/id624499138');

  // Settings
  static Uri privacyPolicyUri =
      Uri.parse('https://cafeanalog.dk/privacy-policy/');

  static Uri feedbackFormUri =
      Uri.parse('https://www.cognitoforms.com/CafeAnalog1/BugReport');
}
