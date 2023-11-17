import 'package:coffeecard/app.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureServices();
  runApp(App());
}
