import 'package:screen_brightness/screen_brightness.dart' as sb;

class ScreenBrightness {
  Future<void> setScreenBrightness(double brightness) async =>
      sb.ScreenBrightness().setScreenBrightness(brightness);
  Future<void> resetScreenBrightness() async =>
      sb.ScreenBrightness().resetScreenBrightness();
}
