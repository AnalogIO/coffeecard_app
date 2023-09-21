// Uri.parse does not return a const, so all globals can't be made const
// ignore_for_file: avoid-global-state
class ApiUriConstants {
  static Uri shiftyUrl = Uri.parse('https://analogio.dk/shiftplanning');
  static const String apiVersion = '1';
  static const String minAppVersion = '2.1.0';
  static Uri analogIOGitHub = Uri.parse('https://github.com/AnalogIO/');

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
