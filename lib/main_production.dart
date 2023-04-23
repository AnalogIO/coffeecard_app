import 'package:coffeecard/app.dart';
import 'package:coffeecard/firebase_options.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.production);
  configureServices();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(App());
}
