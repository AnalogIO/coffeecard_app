import 'package:coffeecard/app.dart';
import 'package:coffeecard/firebase_options.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  // Don't care about the return values of these variables. _ can't be used due to multiple variables needing to be discarded
  //ignore_for_file: avoid-ignoring-return-values
  WidgetsFlutterBinding.ensureInitialized();

  // Set up Hive for local storage
  await Hive.initFlutter();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.development);
  configureServices();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(App());
}
